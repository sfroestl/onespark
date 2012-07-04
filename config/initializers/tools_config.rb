GITHUB_CONFIG = YAML.load_file("#{Rails.root}/config/tools/github.yml")
DBOX_CONFIG = YAML.load_file("#{Rails.root}/config/tools/dropbox.yml")
# config.load_paths += Dir["#{RAILS_ROOT}/app/models/*"].find_all { |f| File.stat(f).directory? }
