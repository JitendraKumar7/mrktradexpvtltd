import './base/libraryExport.dart';

class GalleryScreen extends StatefulWidget {
  final KonnectDetails konnectDetails;

  GalleryScreen(this.konnectDetails);

  @override
  State<StatefulWidget> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<Map> _list;

  @override
  void initState() {
    super.initState();

    ApiClient().getGallery().then((value) => {
          setState(() {
            _list = List<Map>();
            Map response = value.data;
            if (response['status'] == '200') {
              response['result'].forEach((v) {
                _list.add(v);
              });
            }
            print(response);
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    List<CoverImage> _coverImage = widget.konnectDetails.coverImage;
    BasicInfo _basicInfo = widget.konnectDetails.basicInfo;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Gallery'),
      ),
      body: ListView(children: <Widget>[
        CarouselSlider(images: _coverImage, info: _basicInfo),
        _list == null
            ? Center(
                child: GFLoader(loaderColorOne: Colors.white),
              )
            : Column(
                children: _list.map((item) {
                List<String> _images = List<String>();
                item['title_images'].forEach((v) => _images.add(v['images']));
                return ListTile(
                  title: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      item['title'],
                    ),
                  ),
                  subtitle: StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    itemCount: _images.length,
                    physics: NeverScrollableScrollPhysics(),
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    itemBuilder: (BuildContext context, int index) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ImageSliderViewScreen(
                              images: _images,
                              position: index,
                            ),
                          ),
                        );
                      },
                      child: FadeInImage.assetNetwork(
                        image: _images[index],
                        placeholder: 'images/iv_empty.png',
                        height: 80,
                      ),
                    ),
                  ),
                );
              }).toList()),
      ]),
    );
  }
}

class ImageSliderViewScreen extends StatelessWidget {
  final List<String> images;
  final int position;

  const ImageSliderViewScreen(
      {Key key, @required this.images, this.position = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Slider View')),
      body: GFCarousel(
        initialPage: position,
        height: MediaQuery.of(context).size.height,
        items: images.map(
          (imagePath) {
            return PinchZoomImage(
              image: FadeInImage.assetNetwork(
                image: imagePath,
                placeholder: 'images/iv_empty.png',
              ),
            );
          },
        ).toList(),
        autoPlay: true,
        pagination: true,
        viewportFraction: 1.0,
        pauseAutoPlayOnTouch: Duration(seconds: 2),
      ),
    );
  }
}
