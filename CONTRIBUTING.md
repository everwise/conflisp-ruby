# Contributing

Contributions are welcome! We basically follow the [Github
flow](https://guides.github.com/introduction/flow/) and welcome any PR.

For any small changes, feel free to go ahead and open a PR. If it is a bigger
change, please consider opening an issue to discuss it first.

## Set up

Install the dependencies:

```bash
$ bundle
```

Done.

## Tests

We have 100% test coverage using rspec and SimpleCov.

You can run the tests by simply running

```bash
$ rspec
```

## Deploying

If you have write access to the repository, you can deploy the gem to
RubyGems.org.

Steps:

1.  Make sure the [Changelog](./CHANGELOG.md) is up to date.

2.  Tag the version

    ```bash
    $ git tag -a 1.0.1
    ```

3.  Push to Github

    ```bash
    $ git push origin 1.0.1
    ```
