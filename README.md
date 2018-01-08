# init-node-env

- Initialize a few essential initialization to the node app to support multi-environment `.env` files.

# use

> install

    # if you use `yarn`
    yarn global add init-node-env
    # if you use `npm`
    npm install -g init-node-env

> from the root of the project you'd like to initialize

    init-node-env $PWD

# about

### 1. environment types

- `local`
    - for seat-specific environments.
- `test`
    - for integration/unit tests environments.
- `develop`
    - for remotely deployed servers to share the development servers among the internal developers.
- `master`
    - for QAing and staging before production.
- `production`
    - for production release to be used by real users.

### 2. encrypted and decrypted

- For security, we're encrypting each `.env` files using aes-256-cbc.
- When using the `.env` files, we decypt them. The passwords to decrypt environments should be shared amongst the authorized team members safely.

### 3. filenames

- `.env`
    + has the highest precendences to use this environment.
    + *NOT* intended to be modified directly; this file must be the derived product during the build (e.g. by Jenkins build server).
- `.env.(local|test|develop|master|production).(encrypted|decrypted)`

### 4. [husky](https://github.com/typicode/husky) hook

- triggers automatic encryption and rename of the files from `.env.(local|test|develop|master|production).decrypted`  to `.env.(local|test|develop|master|production).encrypted`.

### 5. `.gitignore`

- must include `.env.*.decrypted` and `.env` as these files may contain sensitive data.

# TODO

- [ ] validator in the `precommit` if `init-node-app` is installed correctly.
- [ ] improve README.md with why, how