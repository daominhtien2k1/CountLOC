import 'dart:convert';
import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';
import 'package:cosmetic_frontend/models/models.dart' hide Image;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../blocs/post/post_bloc.dart';
import '../../blocs/post/post_event.dart';
import '../../routes.dart';

import '../../constants/localdata/local_data.dart';
import './widgets/post_widgets.dart';

class CreatePostScreen extends StatefulWidget  {

  CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // In any case, when you are using a TextEditingController (or maintaining any mutable state), then you should use a StatefulWidget and keep the state in the State class.
  final TextEditingController textEditingController = TextEditingController();
  String? status;
  List<ProductSearchItem>? attachedProducts;

  //isMinimizeDraggableScrollableSheet
  bool isMinimizeDSS = false;

  // chức năng ảnh/video
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList; // luồng vẫn hơi củ chuối
  dynamic _pickImageError;
  late VideoPlayerController _controller; // tính năng video chưa được
  bool isVideo = false;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = (value == null ? null : <XFile>[value]);
  }

  Future<void> _playVideo(XFile? file) async {
    if (file != null) {
      _controller.dispose();
      if (kIsWeb) {
        _controller = VideoPlayerController.network(file.path);
      } else {
        _controller = VideoPlayerController.file(File(file.path));
      }
      const double volume = kIsWeb ? 0.0 : 1.0;
      await _controller.setVolume(volume);
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.play();
    }
  }

  Widget _previewVideo() {
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: VideoPlayer(_controller),
    );
  }

  Widget _previewImages() {
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        // child: ListView.builder(
        //   primary: false,
        //   shrinkWrap: true,
        //   key: UniqueKey(),
        //   itemBuilder: (BuildContext context, int index) {
        //     // Why network for web?
        //     // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        //     return Semantics(
        //       label: 'image_picker_example_picked_image',
        //       child: kIsWeb
        //           ? Image.network(_imageFileList![index].path)
        //           : Image.file(File(_imageFileList![index].path)),
        //     );
        //   },
        //   itemCount: _imageFileList!.length,
        // ),
          child: GridView.builder(
            primary: false,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 4,
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2),
            ),
            itemCount: _imageFileList!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {

                },
                child: GridTile(
                    child: Semantics(
                        label: 'image_picker_example_picked_image',
                        child: kIsWeb
                            ? Image.network(_imageFileList![index].path)
                            : Image.file(File(_imageFileList![index].path)),
                      )
                ),
              );
            },
          )
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Bạn chưa chọn ảnh nào',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    if (isVideo) {
      return _previewVideo();
    } else {
      return _previewImages();
    }
  }

  Future<void> _onImageButtonPressed(ImageSource source, {BuildContext? context, bool isMultiImage = false, required bool isVideo}) async {
    if (isVideo) {
      setState(() {
        this.isVideo = true;
      });
      final XFile? file = await _picker.pickVideo(source: source, maxDuration: const Duration(seconds: 10));
      await _playVideo(file);
    } else if (isMultiImage) {
      try {
        final List<XFile> pickedFileList = await _picker.pickMultiImage();
        setState(() {
          _imageFileList = pickedFileList;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();

  }

  handleCreatePost() {
    final described = textEditingController.text;
    // print(_imageFileList?[0]);
    context.read<PostBloc>().add(PostAdd(described: described, status: status, imageFileList: _imageFileList));
  }

  void handleUnattachedProductItem(ProductSearchItem productSearchItem) {
    setState(() {
      if (attachedProducts!.contains(productSearchItem)) {
        attachedProducts!.remove(productSearchItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("#Create_post_screen: Rebuild");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PostAppbar(
        title: 'Tạo bài viết',
        action: 'Đăng',
        textEditingController: textEditingController,
        onHandleCreatePost: handleCreatePost,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: PostInfo(avtUrl: currentUser.imageUrl, name: currentUser.name, status: status),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Nhập nội dung",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    controller: textEditingController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Chia sẻ nội dung của bạn',
                      hintMaxLines: 2,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Hình ảnh",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () async {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return buildImageModalBottomSheet();
                  });
                },
                child: DashedBorderContainer(
                  width: 80,
                  height: 80,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Center(
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: _imageFileList != null ? _handlePreview() : const SizedBox.shrink(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Gắn sản phẩm",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () async {
                  List<ProductSearchItem>? result = await showModalBottomSheet<List<ProductSearchItem>>(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return buildProductModalBottomSheet(context);
                      });
                  setState(() {
                    if (result != null) {
                      attachedProducts = result;
                    }
                  });
                },
                child: DashedBorderContainer(
                  width: 80,
                  height: 80,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Center(
                    child: Icon(
                      Icons.color_lens,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: attachedProducts != null ? _handlePreviewAttachedProduct() : const SizedBox.shrink(),
            ),

          ],
        ),
      ),

    );
  }

  Widget buildImageModalBottomSheet() {
    return Material(
      elevation: 20,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20)
      ),
      color: Colors.white,
      child: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: 40,
              color: Colors.grey[400],
              height: 2,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return ListTile(
                      onTap: () {
                        _onImageButtonPressed(ImageSource.gallery, context: context, isVideo: false);
                      },
                      leading: Icon(Icons.photo, color: Colors.green),
                      title: Text('Ảnh từ gallery')
                    );
                  case 1:
                    return ListTile(
                        onTap: () {
                          _onImageButtonPressed(ImageSource.gallery, context: context, isMultiImage: true, isVideo: false);
                        },
                        leading: Icon(Icons.photo_library, color: Colors.green),
                        title: Text('Nhiều ảnh từ gallery')
                    );
                  case 2:
                    return ListTile(
                        onTap: () {
                          _onImageButtonPressed(ImageSource.camera, context: context, isVideo: false);
                        },
                        leading: Icon(Icons.camera, color: Colors.red),
                        title: Text('Chụp ảnh')
                    );
                  case 3:
                    return ListTile(
                        onTap: () {
                          _onImageButtonPressed(ImageSource.gallery, context: context, isVideo: true);
                        },
                        leading: Icon(Icons.video_library, color: Colors.red),
                        title: Text('Video từ gallery')
                    );
                  case 4:
                    return ListTile(
                        onTap: () {
                          _onImageButtonPressed(ImageSource.camera, context: context, isVideo: true);
                        },
                        leading: Icon(Icons.videocam, color: Colors.red),
                        title: Text('Quay video')
                    );
                  case 5:
                    return ListTile(
                        onTap: () async {
                          final statusGetBack = await Navigator.of(context).pushNamed(Routes.emotion_screen, arguments: status) as String?;
                          // print("#Create_post_screen: $statusGetBack");
                          setState(() {
                            this.status = statusGetBack;
                          });
                          },
                        leading: Icon(Icons.emoji_emotions_outlined, color: Colors.orange),
                        title: Text('Cảm xúc')
                    );
                  case 6:
                    return ListTile(
                        onTap: () {},
                        leading: Icon(Icons.text_format, color: Colors.blue, size: 28),
                        title: Text('Màu nền')
                    );
                  default:
                    return ListTile(
                        onTap: () {},
                        leading: Icon(Icons.photo_library, color: Colors.green),
                        title: Text('Ảnh/video')
                    );
                }
              }),
          ),
        ],
      ),
    );
  }

  Widget buildProductModalBottomSheet(BuildContext context) {
    return Material(
      elevation: 20,
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(20)
      ),
      color: Colors.white,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                width: 40,
                color: Colors.grey[400],
                height: 2,
              ),
            ),
            SizedBox(height: 12),
            Expanded(
                child: ProductListSearch()
            )
          ],
        ),
      ),
    );
  }

  Widget _handlePreviewAttachedProduct() {
    return ListView.builder(
      itemCount: attachedProducts?.length,
      itemBuilder: (context, index) {
        final ProductSearchItem attachedProduct = attachedProducts![index];
        return AttachedProductItemContainer(attachedProductItem: attachedProduct, onHandleUnattachedProductItem: handleUnattachedProductItem);
      },
      shrinkWrap: true,
    );
  }
}

class ProductListSearch extends StatefulWidget {
  const ProductListSearch({ Key? key }) : super(key: key);

  @override
  _ProductListSearchState createState() => _ProductListSearchState();
}

class _ProductListSearchState extends State<ProductListSearch> {
  List<ProductSearchItem> products = [];
  List<ProductSearchItem> _foundedProducts = [];
  List<ProductSearchItem> _selectedProducts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final product1 = ProductSearchItem(
        id: '1',
        slug: 'slug',
        name: 'Dưỡng chất AAA thích hợp cho mặt mụn, cho người khó thích ứng với các loại ',
        image: ProductSearchItemImage.fromJson(jsonDecode('''
          {
              "url": "https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcS0lxE3eUOzeSXuy0mBYUlSirTz9Empm5TeZ5Jwta78aOMWft-qJibo3wLwKjctPgcUoFczneiyd4iVgmcuUfJioraVqrttEOdqJufKaWHNw3Pa-IAlE2vKyXWOkFY-njpUhw&usqp=CAc",
              "publicId": ""
          }
        ''')),
        reviews: 5,
        rating: 3
    );
    final product2 = ProductSearchItem(
        id: '2',
        slug: 'slug',
        name: 'Bị lỗi',
        image: ProductSearchItemImage.fromJson(jsonDecode('''
          {
              "url": "https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcS0lxE3eUOzeSXuy0mBYUlSirTz9Empm5TeZ5Jwta78aOMWft-qJibo3wLwKjctPgcUoFczneiyd4iVgmcuUfJioraVqrttEOdqJufKaWHNw3Pa-IAlE2vKyXWOkFY-njpUhw&usqp=CAc",
              "publicId": ""
          }
        ''')),
        reviews: 5,
        rating: 3
    );
    products = [
      product1,
      product2,
    ];

    setState(() {
      _foundedProducts = products;
    });
  }

  onSearch(String search) {
    setState(() {
      _foundedProducts =
          products.where((product) {
            print("PRINT:" + search.toLowerCase());
            print("PRINT:" + product.name.toLowerCase());
            return product.name.toLowerCase().contains(search.toLowerCase());
          })
              .toList();
    });
  }

  void handleSelectProductItem(ProductSearchItem productSearchItem) {
    setState(() {
      if (_selectedProducts.contains(productSearchItem)) {
        _selectedProducts.remove(productSearchItem);
      } else {
        _selectedProducts.add(productSearchItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (value) => onSearch(value),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500,),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none
                ),
                hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500
                ),
                hintText: "Tìm kiếm"
            ),
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
          child: Text("${_selectedProducts.length} sản phẩm đã chọn"),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ..._selectedProducts.map((selectedProduct) {
                  return Container(
                    constraints: BoxConstraints(
                      maxWidth: 200, // Giới hạn chiều rộng tối đa là 400
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: FilledButton.tonalIcon(
                        onPressed: () {
                          setState(() {
                            handleSelectProductItem(selectedProduct);
                          });
                        },
                        icon: Icon(Icons.close),
                        label: Text(selectedProduct.name, maxLines: 1, overflow: TextOverflow.ellipsis)
                    ),
                  );
                }).toList()
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        Expanded(
          child: Container(
            color: Colors.white,
            child: _foundedProducts.isNotEmpty ? ListView.builder(
                itemCount: _foundedProducts.length,
                itemBuilder: (context, index) {
                  return ProductItemSearchContainer(
                    productSearchItem: _foundedProducts[index],
                    isSelected: _selectedProducts.contains(_foundedProducts[index]),
                    onHandleSelectProductItem: handleSelectProductItem,
                  );
                }) : Center(child: Text(
                "No users found")),
          ),
        ),
        Center(child: OutlinedButton(onPressed: (){
          Navigator.pop(context, _selectedProducts);
        }, child: Text("Hoàn thành"))),
        SizedBox(height: 8),
      ],
    );
  }

}

class ProductItemSearchContainer extends StatelessWidget {
  final ProductSearchItem productSearchItem;
  final bool isSelected;
  final Function(ProductSearchItem) onHandleSelectProductItem;

  ProductItemSearchContainer({required this.productSearchItem, required this.isSelected, required this.onHandleSelectProductItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
          children: [
            Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(productSearchItem.image.url),
                )
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productSearchItem.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        StarList(rating: productSearchItem.rating),
                        SizedBox(width: 8),
                        Text("${productSearchItem.rating}")
                      ],
                    )
                  ]
              ),
            ),
            Checkbox(value: isSelected, onChanged: (bool){
                onHandleSelectProductItem(productSearchItem);
              })
          ]
      ),
    );
  }
}

class AttachedProductItemContainer extends StatelessWidget {
  final ProductSearchItem attachedProductItem;
  final Function(ProductSearchItem) onHandleUnattachedProductItem;

  AttachedProductItemContainer({required this.attachedProductItem, required this.onHandleUnattachedProductItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black12)
      ),
      margin: EdgeInsets.only(top: 6, bottom: 6),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
          children: [
            Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(attachedProductItem.image.url),
                )
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(attachedProductItem.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        StarList(rating: attachedProductItem.rating),
                        SizedBox(width: 8),
                        Text("${attachedProductItem.rating}")
                      ],
                    )
                  ]
              ),
            ),
            IconButton(onPressed: (){
              onHandleUnattachedProductItem(attachedProductItem);
            }, icon: Icon(Icons.close))
          ]
      ),
    );
  }
}