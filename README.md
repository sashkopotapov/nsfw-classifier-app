# NSFW Content Detection iOS App

This repository contains a sample project demonstrating how to develop and integrate a local NSFW (Not Safe For Work) content detection model for iOS apps. The project uses Apple's [CreateML](https://developer.apple.com/machine-learning/create-ml/), [CoreML](https://developer.apple.com/documentation/coreml), and [Vision](https://developer.apple.com/documentation/vision/) frameworks.

## Overview

The primary goal of this project is to enhance app safety by filtering or blurring inappropriate content while preserving user privacy through on-device processing. This approach is particularly beneficial for end-to-end encrypted (E2EE) applications, where server-side content filtering is not possible.

For a detailed explanation of the project, refer to the [Medium article](https://medium.com/@opotapov.business/enhancing-ios-app-safety-with-local-nsfw-detection-using-coreml-and-vision-framework-016c13d1cd98).

### Usage

1. **Open the project in Xcode:**

    ```bash
    open NSFWClassifierApp.xcodeproj
    ```

2. **Run the app on a real iOS device:**

    CoreML models do not work in the simulator, so you need to run the app on a real device.

3. **Classify and blur images:**

    The app displays a feed of posts with images. NSFW images are automatically blurred using the integrated model.

## Contributing

Feel free to submit issues and pull requests for any improvements or additional features.

## License

This project is licensed under the MIT License.

## Acknowledgements

- [CreateML](https://developer.apple.com/machine-learning/create-ml/)
- [CoreML](https://developer.apple.com/documentation/coreml)
- [Vision](https://developer.apple.com/documentation/vision)
- [NSFW Data Scraper](https://github.com/alex000kim/nsfw_data_scraper)

For more detailed information, refer to the [Medium article](https://medium.com/@opotapov.business/enhancing-ios-app-safety-with-local-nsfw-detection-using-coreml-and-vision-framework-016c13d1cd98).
