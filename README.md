# echo-web

[echo-web](http://github.com/artsy/echo-web) is a minimal UI for [echo API](http://github.com/artsy/echo).

[![Build Status](https://semaphoreci.com/api/v1/projects/d7fd078c-6bb1-483a-b6b7-8936e51eb464/479132/badge.svg)](https://semaphoreci.com/artsy-it/echo-web)

Meta
---

* __State:__ production
* __Github:__ [https://github.com/artsy/echo-web/](https://github.com/artsy/echo-web/)
* __CI:__ [Semaphore](https://semaphoreci.com/artsy-it/echo-web/)
* __Point People:__ [@dylanfareed](https://github.com/dylanfareed); [@orta](https://github.com/orta)

Set-Up for Development
---

- Fork [artsy/echo-web](https://github.com/artsy/echo-web)
- Clone your fork locally; for example:
```
git clone git@github.com:dylanfareed/echo-web.git
```
- Bundle
```
cd echo-web
bundle
```
- Verify that [Rubocop](https://github.com/bbatsov/rubocop) and specs pass.
```
RACK_ENV=test bundle exec rake
```
