A minimum example to trigger the error described in https://github.com/rubygems/rubygems/issues/5422.

The `Gemfile.lock` was built with `force_ruby_platform` set to `true`.

---

I noticed the problem locally when trying to install `sorbet` (resp `sorbet-static`) 
in a Docker container on an Apple M1 mac.

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
