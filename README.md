# Unity Orb

[![CircleCI Build Status](https://circleci.com/gh/game-ci/unity-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/game-ci/unity-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/game-ci/unity.svg)](https://circleci.com/orbs/registry/orb/game-ci/unity) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/game-ci/unity-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

Easily build and test your Unity project.

---

## Resources

[CircleCI Orb Registry Page](https://circleci.com/orbs/registry/orb/game-ci/unity) - The official registry page of this orb for all versions, executors, commands, and jobs described.

[CircleCI Orb Docs](https://circleci.com/docs/2.0/orb-intro/#section=configuration) - Docs for using, creating, and publishing CircleCI Orbs.

### How to Contribute

We welcome [issues](https://github.com/game-ci/unity-orb/issues) and [pull requests](https://github.com/game-ci/unity-orb/pulls) against this repository! For detailed guidelines, see [CONTRIBUTING.md](./CONTRIBUTING.md).

### How to Publish An Update

1. Merge pull requests with desired changes to the main branch.
    - For the best experience, squash-and-merge and use [Conventional Commit Messages](https://conventionalcommits.org/).
2. Find the current version of the orb.
    - You can run `circleci orb info game-ci/unity | grep "Latest"` to see the current version.
3. Create a [new Release](https://github.com/game-ci/unity-orb/releases/new) on GitHub.
    - Click "Choose a tag" and _create_ a new [semantically versioned](http://semver.org/) tag. (ex: v1.0.0)
      - We will have an opportunity to change this before we publish if needed after the next step.
4.  Click _"+ Auto-generate release notes"_.
    - This will create a summary of all of the merged pull requests since the previous release.
    - If you have used _[Conventional Commit Messages](https://conventionalcommits.org/)_ it will be easy to determine what types of changes were made, allowing you to ensure the correct version tag is being published.
5. Now ensure the version tag selected is semantically accurate based on the changes included.
6. Click _"Publish Release"_.
    - This will push a new tag and trigger your publishing pipeline on CircleCI.

## Development and Manual Deploy

> **Note:** Development and private orbs should only be used for testing purposes. Always review and validate changes thoroughly before using in production.

If you want to contribute to this orb or deploy a private version for testing, follow these steps:

1. **Fork this repository (optional for private orbs).**
2. **Set your namespace and orb name** to make the steps easier:

   ```bash
   export NAMESPACE="<your-namespace>"
   export ORB_NAME="<your-orb-name>"
   export VERSION="dev:first"
   ```

3. **Pack and publish your orb:**

   ```bash
   circleci orb pack src > unity-orb.yml
   circleci orb publish unity-orb.yml "$NAMESPACE/$ORB_NAME@$VERSION"
   ```

4. **Use your orb in your CircleCI workflow:**

   Update your `.circleci/config.yml` to reference your custom version:

   ```yaml
   orbs:
     unity: <your-namespace>/<your-orb-name>@dev:first
   ```

5. **Promote the version** to a higher semantic version if needed (optional):

   ```bash
   circleci orb publish promote "$NAMESPACE/$ORB_NAME@$VERSION" patch
   ```

## License

[MIT](LICENSE)
