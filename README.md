# A puppet control-repo

See the [Original-Readme](Original-Readme.md) for background and heritage of this repo. 

## Testing

The main reason for this control-repo existing is to demonstrate various ways to test it. The tests are set up to be executed on the following CI/CD systems:

* [GitLab](https://gitlab.com/jessereynolds/control-repo-fbz/pipelines) - from the [GitLab repo](https://gitlab.com/jessereynolds/control-repo-fbz/tree/production)
* [GitHub Actions](https://github.com/jessereynolds/control-repo-fbz/actions) - from the [GitHub repo](https://github.com/jessereynolds/control-repo-fbz)
* [Travis CI](https://travis-ci.com/jessereynolds/control-repo-fbz) - from the [GitHub repo](https://github.com/jessereynolds/control-repo-fbz)
* [Azure DevOps](https://dev.azure.com/jessereynolds/control-repo-fbz/_build) - from the [Azure DevOps repo](https://dev.azure.com/jessereynolds/_git/control-repo-fbz)

### Preparing

Install Ruby 2.5.x or thereabouts using rbenv.

Install the bundler gem with `gem install bundler`

Install the Ruby gems that the tests in this repo depend upon:

```
bundle install
```

Or update the Ruby gem versions (re-resolve dependencies) with:

```
bundle update
```

### Syntax Test

```
bundle exec rake syntax
```

### Lint Test

```
bundle exec rake lint
```

### Onceover Test - Catalog Compile for all Roles

```
bundle exec onceover run spec
```

