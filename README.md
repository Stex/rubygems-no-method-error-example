A minimum example to trigger the error described in https://github.com/rubygems/rubygems/issues/5422.

The `Gemfile.lock` was built with `force_ruby_platform` set to `true`.

---

I noticed the problem locally when trying to install `sorbet` (resp `sorbet-static`) 
in a Docker container on an Apple M1 mac:

```
❯ docker build .
[+] Building 7.5s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                                                                                                                                                                                                                                                                                                                                     0.0s
 => => transferring dockerfile: 164B                                                                                                                                                                                                                                                                                                                                                                                                                                                     0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                                                                                                                                                                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                                                                                                                                                                                                                                                                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/ruby:3.1.2                                                                                                                                                                                                                                                                                                                                                                                                                            1.1s
 => [auth] library/ruby:pull token for registry-1.docker.io                                                                                                                                                                                                                                                                                                                                                                                                                              0.0s
 => [internal] load build context                                                                                                                                                                                                                                                                                                                                                                                                                                                        3.4s
 => => transferring context: 30.92kB                                                                                                                                                                                                                                                                                                                                                                                                                                                     3.3s
 => [1/5] FROM docker.io/library/ruby:3.1.2@sha256:e75f1da5372940f6997c94c9c48db8e4292fb625ca49035fa53e7e5b9124d6fb                                                                                                                                                                                                                                                                                                                                                                      0.0s
 => CACHED [2/5] WORKDIR /app                                                                                                                                                                                                                                                                                                                                                                                                                                                            0.0s
 => [3/5] COPY ./ ./                                                                                                                                                                                                                                                                                                                                                                                                                                                                     0.2s
 => [4/5] RUN bundle config set --local path '/gems'                                                                                                                                                                                                                                                                                                                                                                                                                                     0.3s
 => ERROR [5/5] RUN bundle install                                                                                                                                                                                                                                                                                                                                                                                                                                                       2.4s
------
 > [5/5] RUN bundle install:
#10 0.271 Bundler 2.3.7 is running, but your lockfile was generated with 2.3.11. Installing Bundler 2.3.11 and restarting using that version.
#10 1.352 Fetching gem metadata from https://rubygems.org/.
#10 1.385 Fetching bundler 2.3.11
#10 1.501 Installing bundler 2.3.11
#10 2.072 Fetching gem metadata from https://rubygems.org/.
#10 2.275 Resolving dependencies...
#10 2.288 Your lockfile was created by an old Bundler that left some things out.
#10 2.288 Because of the missing DEPENDENCIES, we can only install gems one at a time, instead of installing 5 at a time.
#10 2.288 You can fix this by adding the missing gems to your Gemfile, running bundle install, and then removing the gems from your Gemfile.
#10 2.288 The missing gems are:
#10 2.288 * sorbet-static depended upon by sorbet
#10 2.288 Using bundler 2.3.11
#10 2.289 Fetching sorbet 0.5.9889
#10 2.358 Installing sorbet 0.5.9889
#10 2.387 --- ERROR REPORT TEMPLATE -------------------------------------------------------
#10 2.387
#10 2.387 ```
#10 2.387 NoMethodError: undefined method `full_name' for nil:NilClass
#10 2.387
#10 2.387   warning << "* #{unmet_spec_dependency}, depended upon #{spec.full_name}, unsatisfied by #{@specs.find {|s| s.name == unmet_spec_dependency.name && !unmet_spec_dependency.matches_spec?(s.spec) }.full_name}"
#10 2.387                                                                                                                                                                                                    ^^^^^^^^^^
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer/parallel_installer.rb:124:in `block (2 levels) in check_for_unmet_dependencies'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer/parallel_installer.rb:123:in `each'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer/parallel_installer.rb:123:in `block in check_for_unmet_dependencies'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer/parallel_installer.rb:122:in `each'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer/parallel_installer.rb:122:in `check_for_unmet_dependencies'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer/parallel_installer.rb:100:in `call'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer/parallel_installer.rb:71:in `call'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer.rb:259:in `install_in_parallel'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer.rb:209:in `install'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer.rb:89:in `block in run'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/process_lock.rb:12:in `block in lock'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/process_lock.rb:9:in `open'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/process_lock.rb:9:in `lock'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer.rb:71:in `run'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/installer.rb:23:in `install'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/cli/install.rb:62:in `run'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/cli.rb:255:in `block in install'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/settings.rb:131:in `temporary'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/cli.rb:254:in `install'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/vendor/thor/lib/thor/command.rb:27:in `run'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/vendor/thor/lib/thor/invocation.rb:127:in `invoke_command'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/vendor/thor/lib/thor.rb:392:in `dispatch'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/cli.rb:31:in `dispatch'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/vendor/thor/lib/thor/base.rb:485:in `start'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/cli.rb:25:in `start'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/exe/bundle:48:in `block in <top (required)>'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/lib/bundler/friendly_errors.rb:103:in `with_friendly_errors'
#10 2.387   /gems/ruby/3.1.0/gems/bundler-2.3.11/exe/bundle:36:in `<top (required)>'
#10 2.387   /usr/local/bin/bundle:25:in `load'
#10 2.387   /usr/local/bin/bundle:25:in `<main>'
#10 2.387 ```
#10 2.387
#10 2.387 ## Environment
#10 2.387
#10 2.387 ```
#10 2.387 Bundler       2.3.11
#10 2.387   Platforms   ruby, aarch64-linux
#10 2.387 Ruby          3.1.2p20 (2022-04-12 revision 4491bb740a9506d76391ac44bb2fe6e483fec952) [aarch64-linux]
#10 2.387   Full Path   /usr/local/bin/ruby
#10 2.387   Config Dir  /usr/local/etc
#10 2.387 RubyGems      3.3.7
#10 2.387   Gem Home    /gems/ruby/3.1.0
#10 2.387   Gem Path    /gems/ruby/3.1.0
#10 2.387   User Home   /root
#10 2.387   User Path   /root/.local/share/gem/ruby/3.1.0
#10 2.387   Bin Dir     /gems/ruby/3.1.0/bin
#10 2.387 OpenSSL
#10 2.387   Compiled    OpenSSL 1.1.1n  15 Mar 2022
#10 2.387   Loaded      OpenSSL 1.1.1n  15 Mar 2022
#10 2.387   Cert File   /usr/lib/ssl/cert.pem
#10 2.387   Cert Dir    /usr/lib/ssl/certs
#10 2.387 Tools
#10 2.387   Git         2.30.2
#10 2.387   RVM         not installed
#10 2.387   rbenv       not installed
#10 2.387   chruby      not installed
#10 2.387 ```
#10 2.387
#10 2.387 ## Bundler Build Metadata
#10 2.387
#10 2.387 ```
#10 2.387 Built At          2022-04-07
#10 2.387 Git SHA           9b6c5a801a
#10 2.387 Released Version  true
#10 2.387 ```
#10 2.387
#10 2.387 ## Bundler settings
#10 2.387
#10 2.387 ```
#10 2.387 app_config
#10 2.387   Set via BUNDLE_APP_CONFIG: "/usr/local/bundle"
#10 2.387 path
#10 2.387   Set for your local app (/usr/local/bundle/config): "/gems"
#10 2.387 silence_root_warning
#10 2.387   Set via BUNDLE_SILENCE_ROOT_WARNING: true
#10 2.387 ```
#10 2.387
#10 2.387 ## Gemfile
#10 2.387
#10 2.387 ### Gemfile
#10 2.387
#10 2.387 ```ruby
#10 2.387 source "https://rubygems.org"
#10 2.387 git_source(:github) { |repo| "https://github.com/#{repo}.git" }
#10 2.387
#10 2.387 ruby "3.1.2"
#10 2.387
#10 2.387 group :development do
#10 2.387   gem "sorbet", "0.5.9889"
#10 2.387 end
#10 2.387 ```
#10 2.387
#10 2.387 ### Gemfile.lock
#10 2.387
#10 2.387 ```
#10 2.387 GEM
#10 2.387   remote: https://rubygems.org/
#10 2.387   specs:
#10 2.387     sorbet (0.5.9889)
#10 2.387       sorbet-static (= 0.5.9889)
#10 2.387     sorbet-static (0.5.9889-universal-darwin-14)
#10 2.387     sorbet-static (0.5.9889-universal-darwin-15)
#10 2.387     sorbet-static (0.5.9889-universal-darwin-16)
#10 2.387     sorbet-static (0.5.9889-universal-darwin-17)
#10 2.387     sorbet-static (0.5.9889-universal-darwin-18)
#10 2.387     sorbet-static (0.5.9889-universal-darwin-19)
#10 2.387     sorbet-static (0.5.9889-universal-darwin-20)
#10 2.387     sorbet-static (0.5.9889-universal-darwin-21)
#10 2.387     sorbet-static (0.5.9889-x86_64-linux)
#10 2.387
#10 2.387 PLATFORMS
#10 2.387   ruby
#10 2.387
#10 2.387 DEPENDENCIES
#10 2.387   sorbet (= 0.5.9889)
#10 2.387
#10 2.387 RUBY VERSION
#10 2.387    ruby 3.1.2p20
#10 2.387
#10 2.387 BUNDLED WITH
#10 2.387    2.3.11
#10 2.387 ```
#10 2.387
#10 2.387 --- TEMPLATE END ----------------------------------------------------------------
#10 2.387
#10 2.387 Unfortunately, an unexpected error occurred, and Bundler cannot continue.
#10 2.388
#10 2.388 First, try this link to see if there are any existing issue reports for this error:
#10 2.388 https://github.com/rubygems/rubygems/search?q=undefined+method+%60full_name%27+for+nil+NilClass&type=Issues
#10 2.388
#10 2.388 If there aren't any reports for this error yet, please fill in the new issue form located at https://github.com/rubygems/rubygems/issues/new?labels=Bundler&template=bundler-related-issue.md, and copy and paste the report template above in there.
------
executor failed running [/bin/sh -c bundle install]: exit code: 1
```

It turned out, there simply is no gem version of `sorbet-static` for `aarch64-linux`
which caused bundler to crash itself.

If anyone should make it here with the same problem through Google:
As my Docker images are mainly used in CI (which is `amd64`), I simply
disabled installing sorbet in containers on M1 macs completely.

```ruby
# Gemfile

install_if -> { RUBY_PLATFORM != "aarch64-linux" } do
  gem "sorbet", "0.5.9889"
end
```
