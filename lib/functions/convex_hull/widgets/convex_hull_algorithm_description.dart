import 'package:fife_image/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:url_launcher/url_launcher.dart';

class ConvexHullAlgorithmDescription extends StatelessWidget {
  const ConvexHullAlgorithmDescription({super.key});

  final String _markdownData = """
```
for each channel:
    user selects area of highest background signal

user selects crop area on overlay image

for each channel:
    calculate subtraction value = 3 (standard deviation) + mean
    subtract subtraction value from the image

    if rgb values < 10:
        set value to 0

    apply crop area to image

for insulin and glucagon channels:
    remove small objects from image

combine insulin and glucagon channels
apply convex hull to insulin/glucagon combined image

calculate statistics
```
""";

  @override
  Widget build(BuildContext context) {
    final imageSize = (MediaQuery.sizeOf(context).width / 4.0) * 0.9;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Convex Hull Algorithm',
            style: kTitleStyle,
          ),
          const Divider(
            color: Colors.white,
            thickness: 1.0,
          ),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'This algorithm was developed by Alex Dwyer and is outlined fully in ',
                  style: kTextStyle,
                ),
                TextSpan(
                  text: 'Enhanced CD4+ and CD8+ T cell infiltrate within convex hull defined'
                      ' pancreatic islet borders as autoimmune diabetes progresses',
                  style: kLinkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      final url = Uri.parse('https://www.nature.com/articles/s4159kParagraphSpacing21-96327-2');
                      launchUrl(url);
                    },
                ),
                const TextSpan(
                  text: '. This algorithm is used to programmatically define the boundaries of a pancreatic islet. Additionally it gives '
                      'the user information about where proteins are located in relation to the islet and how much protein is'
                      ' present in the image. ',
                  style: kTextStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Overview',
            style: kSubtitleStyle,
          ),
          const Divider(
            color: Colors.white,
            thickness: 1.0,
          ),
          Markdown(
            shrinkWrap: true,
            selectable: true,
            data: _markdownData,
            styleSheet: MarkdownStyleSheet(
              codeblockDecoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8.0),
              ),
              code: const TextStyle(
                backgroundColor: Colors.black54,
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: 'monospace',
              ),
              codeblockPadding: const EdgeInsets.all(10.0),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Description',
            style: kSubtitleStyle,
          ),
          const Divider(
            color: Colors.white,
            thickness: 1.0,
          ),
          const Text('You must first specify the number of channels for each image, the height and width of the images and the associated '
              'units of length. Note: All images must have the same number of channels and they must be the same size and scale.'
              ' Next the user must specify the filter text for each channel and the corresponding label. For example if the set of insulin '
              'images are named: image001_ch01_SV.tif, image002_ch01_SV.tif, image003_ch01_SV.tif then you would set the channel 1 '
              'search pattern to \'ch01\'. This tool is most useful if the images have a consistent naming scheme so it may be necessary to '
              'rename files. The user must also specify the search string for the overlay image. Once this is complete press the Start '
              'button'),
          const SizedBox(height: kParagraphSpacing),
          const Text('Note: for the tool to work you must have at least \'Insulin\' and \'Glucagon\' specified as proteins. The algorithm '
              'uses these to determine the outline of the islet'),
          const SizedBox(height: kParagraphSpacing),
          const Text(
              'Next you must go through each channel and specify the region of highest background signal. This is used to perform the'
              ' channel specific background correction. The average and standard deviation of the region is then '
              'computed and a value of:'),
          const TeXView(
            child: TeXViewColumn(
              children: [
                TeXViewColumn(children: [
                  TeXViewDocument(
                    r"""<p>$$\text{subtraction value} = 3 \sigma + \mu$$</p>""",
                    style: TeXViewStyle.fromCSS(
                      'padding: 15px; color: white;',
                    ),
                  )
                ])
              ],
            ),
          ),
          const Text('is subtracted from each pixel in the image. It is very important to only select the brightest areas of background.'),
          const SizedBox(height: kParagraphSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "selection_example.png",
                width: imageSize,
                height: imageSize,
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 32.0,
              ),
              Image.asset(
                "bg_correction_example.png",
                width: imageSize,
                height: imageSize,
              ),
            ],
          ),
          const SizedBox(height: kParagraphSpacing),
          const Text('After background correction has been completed for all image channels you must select the outline of the islet '
              'including the surrounding inflammation. This selected area is applied to all images and statistics are only computed within'
              ' this area. The rest of the image is disregarded. This is done to ensure you are only getting data on the islet of '
              'interest.'),
          const SizedBox(height: kParagraphSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "islet_selection_example.png",
                width: imageSize,
                height: imageSize,
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 32.0,
              ),
              Image.asset(
                "islet_outline_example.png",
                width: imageSize,
                height: imageSize,
              ),
            ],
          ),
          const SizedBox(height: kParagraphSpacing),
          const Text('Once these user completes these steps the convex hull algorithm is applied to the image set. The previously'
              ' selected islet outline area is used to crop each channel and the overlay image so only relevant data is used. This allows'
              'for analysis of images with more than one islet.'),
          const SizedBox(height: kParagraphSpacing),
          const Text('Each image is in the RGB format meaning each color takes on a value between 0 and 255. To further remove background'
              'each image is thresholded such that color values less than 10 are set to 0.'),
          const SizedBox(height: kParagraphSpacing),
          const Text('After thresholding the insulin and glucagon images are converted to masks and added together. Once combined small '
              'objects are removed from the image. This ensures that the convex hull forms around the correct portions of the image and not'
              'just noise.'),
          const SizedBox(height: kParagraphSpacing),
          const Text('The convex hull algorithm is then applied to the combined insulin glucagon mask.'),
          const SizedBox(height: kParagraphSpacing),
          const Text('If the user selected proteins for validation a validation image is aso constructed by combining all the masks for the'
              ' selected proteins. The overlay image with the convex hull and the validation image are viewable by the user.'),
          const SizedBox(height: kParagraphSpacing),
          const Text('Various statistics are then computed for the images such as total glucagon area, total insulin area, etc...'),
          const SizedBox(height: kBottomSpacer),
        ],
      ),
    );
  }
}
//\text{subtraction value} = 3 \times \sigma + \mu
