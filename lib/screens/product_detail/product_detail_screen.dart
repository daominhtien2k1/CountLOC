import 'dart:convert';

import 'package:cosmetic_frontend/blocs/product_detail/product_detail_bloc.dart';
import 'package:cosmetic_frontend/blocs/product_detail/product_detail_event.dart';
import 'package:cosmetic_frontend/blocs/product_detail/product_detail_state.dart';
import 'package:cosmetic_frontend/blocs/review/review_bloc.dart';
import 'package:cosmetic_frontend/blocs/review/review_event.dart';
import 'package:cosmetic_frontend/blocs/review/review_state.dart';
import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';
import 'package:cosmetic_frontend/constants/assets/placeholder.dart';
import 'package:cosmetic_frontend/routes.dart';
import 'package:cosmetic_frontend/screens/home/home_screen.dart';
import 'package:cosmetic_frontend/screens/newsfeed/widgets/newsfeed_widgets.dart';
import 'package:cosmetic_frontend/screens/product_detail/widgets/product_detail_image_carousel.dart';
import 'package:cosmetic_frontend/screens/product_detail/widgets/product_detail_widgets.dart';
import 'package:cosmetic_frontend/screens/product_detail/widgets/review_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../models/models.dart' hide Image;

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProductDetailBloc>(context).add(ProductDetailFetched(productId: productId));
    BlocProvider.of<ReviewBloc>(context).add(ReviewsFetched(productId: productId));
    BlocProvider.of<ReviewBloc>(context).add(InstructionReviewsFetched(productId: productId));
    BlocProvider.of<ReviewBloc>(context).add(StatisticStarReviewFetched(productId: productId));
    BlocProvider.of<ProductDetailBloc>(context).add(RelateProductsFetched(productId: productId));
    BlocProvider.of<ProductDetailBloc>(context).add(ProductCharacteristicsFetched(productId: productId));
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.bookmark_border_outlined)),
          IconButton(onPressed: (){}, icon: Icon(Icons.share_outlined)),
        ],
      ),
      body: SafeArea(
        child: ProductDetailContent(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FavouriteAndReviewContainer(),
      ),
      floatingActionButton: FancyFab(productId: productId),
    );
  }
}

class ProductDetailContent extends StatelessWidget {
  const ProductDetailContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        switch (state.productDetailStatus) {
          case ProductDetailStatus.initial:
            return Center(child: CircularProgressIndicator());
          case ProductDetailStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ProductDetailStatus.failure:
            return Center(child: Text("Failed"));
          case ProductDetailStatus.success: {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      ProductImage(),
                      Positioned(
                        bottom: -24,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: BrandAndInfo(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ProductInfo(),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Characteristic(),
                  ),
                  Divider(thickness: 8, color: Colors.black12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: AvailableInStore(),
                  ),
                  Divider(thickness: 8, color: Colors.black12),
                  ProductDetailDescription(),
                  Divider(thickness: 8, color: Colors.black12),
                  // Trong backend model Product có mảng link các sản phẩm liên quan. Lúc render ra UI thì là danh sách sản phẩm liên quan của hãng + sản phẩm liên quan đến tìm kiếm search của mk + sản phẩm liên quan đến tình trạng hiện tại của mình
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: RelateProductList(),
                  ),
                  Divider(thickness: 8, color: Colors.black12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: RelatePostList(),
                  ),
                  Divider(thickness: 8, color: Colors.black12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InstructionReviewList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ProductReviewList(),
                  )
                ],
              ),
            );
          }
        }
      },

    );
  }
}

class FavouriteAndReviewContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final isLoved = state.productDetail?.isLoved ?? false;
          return Container(
            child: Row(
              children: [
                isLoved ?
                IconButton.filledTonal(onPressed: (){

                }, icon: Icon(Icons.favorite_outlined))
                :
                IconButton.filledTonal(onPressed: (){

                }, icon: Icon(Icons.favorite_border)),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Đánh giá ngay", style: Theme.of(context).textTheme.titleMedium),
                    StarList(rating: 0, size: 24)
                  ],

                ),
              ],
            ),
          );
      }
    );
  }
}

class ProductImage extends StatelessWidget {
  ProductImage({Key? key}) : super(key: key);

  List<Carousel> carousels = [
    Carousel(url: "https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcT3OuIQxdI2ustrh-aekGmKfkTVE3ewuPQYCgLWt_kEpgP5a46eH3TEtGxX7lpNMxVyHxRtzvpQviCQP_aHuiZ25wkhLNarrdv7-kqZ7A3ffTwDnW3jdwn3eMqmDOgHWoS2Njo&usqp=CAc"),
    Carousel(url: "https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcTIwL4xUx-Ek5W8eeVkYgX7Na0DpaAZObJDxsHZQwAPe_T4TYA-UStoMWRzd7NYPUXqt1wZo0E5ONyk9Toi0uGDsf0SOTnu629-VUaOXjlVy7GJ_iATVVR5ov7MwzEkYloiC6s&usqp=CAc"),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final images = state.productDetail?.images;
          carousels = images?.map((e) => Carousel(url: e.url)).toList() ?? carousels;
          return ProductDetailImageCarouselSlider(carouselList: carousels);
        }
    );

  }
}

class BrandAndInfo extends StatelessWidget {
  const BrandAndInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final product = state.productDetail;
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: 124,
                        height: 48,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black12),
                            borderRadius: BorderRadius.all(Radius.circular(16))
                        ),
                        child: GestureDetector(
                          onTap: (){
                            // navigate to brand
                          },
                          child: Row(
                            children: [
                              Image.network(
                                  product?.brand.image.url ?? ImagePlaceHolder.imagePlaceHolderOnline,
                                  width: 32, height: 32),
                              SizedBox(width: 6),
                              Text(product?.brand.name ?? "Brand"),
                              Spacer(),
                              Icon(Icons.navigate_next_outlined)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(onPressed: () {},
                    icon: Icon(Icons.info_outline),
                    iconSize: 32,
                    color: Colors.black26)
              ]
          );
        }
    );
  }
}

class ProductInfo extends StatelessWidget {
  const ProductInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        final product = state.productDetail;
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product?.name ?? "",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  StarList(rating: product?.rating ?? 0),
                  SizedBox(width: 8),
                  Text("${product?.rating.toStringAsFixed(2)}"),
                  SizedBox(width: 4),
                  Text("(${product?.reviews} đánh giá)"),
                  SizedBox(width: 8),
                  Text("|"),
                  SizedBox(width: 8),
                  Icon(Icons.favorite),
                  SizedBox(width: 4),
                  Text("${product?.loves} yêu thích")
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text("${NumberFormat('#,##0').format(product?.lowPrice ?? 0)} đ", style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(width: 16),
                  Text("~", style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(width: 16),
                  Text("${NumberFormat('#,##0').format(product?.highPrice ?? 0)} đ", style: Theme.of(context).textTheme.headlineSmall),
                ],
              )
            ],
          ),
        );
      }
    );
  }
}

class Characteristic extends StatelessWidget {
  const Characteristic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final characteristics = state.characteristics as List<String>?;
          final productId = state.productDetail?.id;
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print("AA");
                    Navigator.pushNamed(context, Routes.product_characteristic_screen, arguments: productId);
                  },
                  child: Row(
                    children: [
                      Text("Đặc trưng của sản phẩm", style: Theme.of(context).textTheme.titleMedium),
                      Spacer(),
                      Icon(Icons.navigate_next)
                    ],
                  ),
                ),
                SizedBox(height: 8),
                characteristics?.length != 0 ? Container(
                  height: 48,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...?characteristics?.map((c) =>
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              child: Chip(label: Text(c))
                            )
                        ).toList()
                      ],
                    ),
                  ),
                )
                : SizedBox()
              ],
            ),
          );
      }
    );
  }
}

class AvailableInStore extends StatelessWidget {
  const AvailableInStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(Icons.storefront),
          SizedBox(width: 8),
          Text("Có sẵn tại cửa hàng"),
          Spacer(),
          Icon(Icons.navigate_next)
        ],
      ),
    );
  }
}

class ProductDetailDescription extends StatelessWidget {
  const ProductDetailDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final product = state.productDetail;
        return Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Thông tin sản phẩm", style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 16),
                  Text(product?.description ?? "",
                     maxLines: 4,
                   overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  BrandInfo()
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2), // Đặt màu nền là màu trắng
                boxShadow: [
                  BoxShadow(
                    color: Colors.white, // Đặt màu shadow
                    offset: Offset(0, -4), // Đặt hướng shadow (0,-4) để đổ ngược lên trên
                    blurRadius: 16, // Đặt bán kính blur cho shadow
                    spreadRadius: 8, // Đặt bán kính mở rộng của shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Xem tất cả", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blueAccent)),
                  Icon(Icons.navigate_next)
                ],
              ),
            )
          ],
        );
      }
    );
  }
}

class BrandInfo extends StatelessWidget {
  const BrandInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final product = state.productDetail;
        return Container(
          child: Row(
            children: [
              Image.network(product?.brand.image.url ?? ImagePlaceHolder.imagePlaceHolderOnline,
                  width: 72, height: 72),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Thương hiệu:"),
                      SizedBox(width: 16),
                      Text(product?.brand.name ?? "")
                    ],
                  ),
                  Row(
                    children: [
                      Text("Sản xuất tại:"),
                      SizedBox(width: 16),
                      Text(product?.brand.origin ?? "")
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mô tả:"),
                      SizedBox(width: 16),
                      SizedBox(
                          width: 232,
                          child: Text(product?.brand.description ?? "",
                              overflow: TextOverflow.clip, maxLines: 2)
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }
}

class ProductReviewList extends StatelessWidget {
  const ProductReviewList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        switch (state.reviewStatus) {
          case ReviewStatus.initial:
            return Center(child: CircularProgressIndicator());
          case ReviewStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ReviewStatus.failure:
            return Center(child: Text("Failed"));
          case ReviewStatus.success: {
            final reviews = state.reviews;
              return Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text("Người dùng đánh giá", style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium),
                        Spacer(),
                        Text("Xem thêm"),
                        Icon(Icons.navigate_next)
                      ],
                    ),
                  ),
                  StatisticStar(),
                  if(reviews!= null) ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reviews?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Review review = reviews![index];
                        return ReviewContainer(review: review);
                      }
                  ),
                ],
              );
            }
        }
      }
    );
  }
}

class RelateProductList extends StatelessWidget {
  RelateProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final List<RelateProduct>? relateProducts = state.relateProducts;
          if (relateProducts != null && relateProducts.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Có thể bạn sẽ thích", style: Theme.of(context).textTheme.titleMedium),
                    Icon(Icons.navigate_next)
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  height: 232,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: 16,
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: relateProducts?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: EdgeInsets.all(0),
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Container(
                          width: 144,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Image.network(
                                      relateProducts?[index].image.url ?? ImagePlaceHolder.imagePlaceHolderOnline,
                                      width: 144,
                                      height: 100,
                                      fit: BoxFit.fitWidth
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 2),
                                    Text("${relateProducts?[index].brandName}", style: Theme.of(context).textTheme.titleSmall),
                                    Text('${relateProducts?[index].name}', style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        StarList(rating: relateProducts?[index].rating ?? 0),
                                        SizedBox(width: 8),
                                        Text("${relateProducts?[index].reviews}")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.favorite_outlined),
                                        SizedBox(width: 4),
                                        Text("${relateProducts?[index].loves} yêu thích"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          } else {
            return SizedBox();
          }

      }
    );
  }
}

class RelatePostList extends StatelessWidget {
  const RelatePostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Text("675 Bài viết liên quan", style: Theme.of(context).textTheme.titleMedium),
                Spacer(),
                Text("Xem thêm"),
                Icon(Icons.navigate_next)
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  const jsonString =
                      '{ "id": "63ddd33e5fa9cf5634bb2820",  "described": "The rough duck calmly ran because some teacher humbly rolled below a dumb hamster which, became a vibrating, lazy hamster.",  "createdAt": "2023-02-04T03:38:38.608Z", "updatedAt": "2023-02-04T03:38:38.608Z", "likes": 0, "comments": 5, "author": {  "id": "63bbff18fc13ae649300082b", "name": "Gussi Waterhouse",  "avatar": "http://dummyimage.com/100x100.png/cc0000/ffffff" }, "is_liked": false, "status": "trống vắng", "is_blocked": false, "can_edit": false, "banned": false,  "can_comment": false, "classification": "General" }';
                  Map<String, dynamic> data = jsonDecode(jsonString);
                  final Post post = Post.fromJson(data);
                  return PostContainer(post: post);
                }
            ),
          ),
        ],
      ),
    );
  }
}

class StatisticStar extends StatelessWidget {
  const StatisticStar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        switch (state.reviewStatus) {
          case ReviewStatus.initial:
            return Center(child: CircularProgressIndicator());
          case ReviewStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ReviewStatus.failure:
            return Center(child: Text("Failed"));
          case ReviewStatus.success: {
            final statisticStar = state.statisticStar;
            return Container(
              padding: const EdgeInsets.only(
                  left: 24, right: 40, bottom: 8, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("${statisticStar?.rating}", style: Theme
                          .of(context)
                          .textTheme
                          .displaySmall),
                      StarList(rating: statisticStar?.rating ?? 0)
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          StarList(rating: 5),
                          SizedBox(width: 24),
                          Text("${statisticStar?.the5StarRatings} đánh giá")
                        ],
                      ),
                      Row(
                        children: [
                          StarList(rating: 4),
                          SizedBox(width: 24),
                          Text("${statisticStar?.the4StarRatings} đánh giá")
                        ],
                      ),
                      Row(
                        children: [
                          StarList(rating: 3),
                          SizedBox(width: 24),
                          Text("${statisticStar?.the3StarRatings} đánh giá")
                        ],
                      ),
                      Row(
                        children: [
                          StarList(rating: 2),
                          SizedBox(width: 24),
                          Text("${statisticStar?.the2StarRatings} đánh giá")
                        ],
                      ),
                      Row(
                        children: [
                          StarList(rating: 1),
                          SizedBox(width: 24),
                          Text("${statisticStar?.the1StarRatings} đánh giá")
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          }
        }

      }
    );
  }
}

class InstructionReviewList extends StatelessWidget {
  const InstructionReviewList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Text("Hướng dẫn và chia sẻ cảm nhận", style: Theme.of(context).textTheme.titleMedium),
                Spacer(),
                Text("Xem thêm"),
                Icon(Icons.navigate_next)
              ],
            ),
          ),
          BlocBuilder<ReviewBloc, ReviewState>(builder: (context, state) {
            switch (state.reviewStatus) {
              case ReviewStatus.initial:
                return Center(child: CircularProgressIndicator());
              case ReviewStatus.loading:
                return Center(child: CircularProgressIndicator());
              case ReviewStatus.failure:
                return Center(child: Text("Failed"));
              case ReviewStatus.success: {
                  final instructionReviews = state.instructionReviews;
                  return Expanded(
                      child: ListView.builder(
                          itemCount: instructionReviews!.length,
                          itemBuilder: (context, index) {
                            final instructionReview = instructionReviews![index];
                            return ReviewContainer(review: instructionReview);
                          }
                      )
                  );
                }
            }
          })
        ],
      ),
    );
  }
}