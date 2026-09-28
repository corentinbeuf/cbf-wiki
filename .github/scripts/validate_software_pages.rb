#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "date"
require "did_you_mean"

SITE_DIR      = ARGV[0] || "data"
PAGE_DIRS     = %w[docker_container].freeze # dossiers dont les pages suivent le plan
LAYOUT        = "software"
REQUIRED_KEYS = %w[layout title parent nav_order].freeze
OPTIONAL_KEYS = %w[has_children grand_parent nav_exclude permalink description].freeze
FRONT_MATTER  = /\A---[ \t]*\r?\n(.*?)\r?\n---[ \t]*(?:\r?\n|\z)(.*)\z/m

$errors = 0

def report(level, file, msg)
  $errors += 1 if level == :error
  msg = msg.gsub(/\s+/, " ")
  if ENV["GITHUB_ACTIONS"]
    puts "::#{level} file=#{file}::#{msg}"
  else
    puts "#{level == :error ? 'ERREUR   ' : 'ATTENTION'} #{file} : #{msg}"
  end
end

def parse(path)
  raw = File.read(path, encoding: "UTF-8")
  m = raw.match(FRONT_MATTER)
  return [nil, nil, "front matter absent ou mal fermé (un `---` au début, un à la fin)"] unless m

  data = YAML.safe_load(m[1], permitted_classes: [Date, Time])
  return [nil, nil, "front matter vide ou invalide"] unless data.is_a?(Hash)

  [data, m[2], nil]
rescue Psych::Exception => e
  [nil, nil, "YAML invalide (indentation ?) : #{e.message}"]
end

def content_files
  prefix = File.join(SITE_DIR, "")
  Dir.glob(File.join(SITE_DIR, "**", "*.{md,markdown}")).reject do |p|
    p.delete_prefix(prefix).split("/").any? { |seg| seg.start_with?("_", ".") || seg == "vendor" }
  end
end

sections = YAML.safe_load(File.read(File.join(SITE_DIR, "_data", "software_sections.yml")))
section_keys      = sections.map { |s| s["key"] }
required_sections = sections.reject { |s| s["optional"] }.map { |s| s["key"] }
allowed           = REQUIRED_KEYS + OPTIONAL_KEYS + section_keys
checker           = DidYouMean::SpellChecker.new(dictionary: allowed)

all_titles = content_files.filter_map { |p| parse(p).first&.fetch("title", nil) }

pages = PAGE_DIRS
        .flat_map { |d| Dir.glob(File.join(SITE_DIR, d, "**", "*.{md,markdown}")) }
        .reject { |p| File.basename(p).start_with?("index.") }
        .sort

by_parent = Hash.new { |h, k| h[k] = [] }
titles_seen = {}

pages.each do |path|
  data, body, err = parse(path)
  if err
    report(:error, path, err)
    next
  end

  REQUIRED_KEYS.each do |k|
    report(:error, path, "clé obligatoire manquante ou vide : #{k}") if data[k].to_s.strip.empty?
  end

  if data["layout"] && data["layout"] != LAYOUT
    report(:error, path, "layout doit valoir `#{LAYOUT}` (actuel : #{data['layout']})")
  end

  (data.keys - allowed).each do |k|
    hint = checker.correct(k).first
    report(:error, path, "clé inconnue `#{k}`#{hint ? " — vouliez-vous dire `#{hint}` ?" : ''}")
  end

  if data["parent"] && !all_titles.include?(data["parent"])
    report(:error, path, "parent `#{data['parent']}` introuvable (il doit être le `title` exact d'une page)")
  end

  unless data["nav_order"].nil? || data["nav_order"].is_a?(Integer)
    report(:error, path, "nav_order doit être un nombre entier")
  end

  required_sections.each do |k|
    report(:error, path, "section obligatoire manquante : #{k}") unless data.key?(k)
  end

  section_keys.each do |k|
    next unless data.key?(k)

    v = data[k]
    unless v.is_a?(String)
      report(:error, path, "section `#{k}` : texte attendu")
      next
    end
    report(:error, path, "section `#{k}` vide") if v.strip.empty? && required_sections.include?(k)
    report(:error, path, "section `#{k}` : bloc de code non fermé (nombre impair de ```)") if v.scan(/^\s*```/).size.odd?
    report(:warning, path, "section `#{k}` : gras dans du code (`**x**` s'affichera avec les astérisques)") if v.match?(/`\*\*[^`\n]+\*\*`/)
    report(:warning, path, "section `#{k}` : TODO ou « À compléter » restant") if v.match?(/TODO|À compléter/i)
  end

  if body.match?(/^\s*(?:#{section_keys.join('|')})\s*:/)
    report(:error, path, "des clés de section sont dans le corps de la page : un `---` en trop dans le front matter ?")
  end

  if (other = titles_seen[data["title"]])
    report(:error, path, "titre déjà utilisé par #{other}")
  end
  titles_seen[data["title"]] = path
  by_parent[data["parent"]] << [data["nav_order"], path]
end

by_parent.each do |parent, list|
  list.group_by(&:first).each do |order, same|
    next if order.nil? || same.size < 2

    report(:warning, same.last.last, "nav_order #{order} déjà utilisé sous `#{parent}`")
  end
end

if $errors.zero?
  puts "OK : #{pages.size} page(s) validée(s)"
else
  puts "#{$errors} erreur(s)"
  exit 1
end