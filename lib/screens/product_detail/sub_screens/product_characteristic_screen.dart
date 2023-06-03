import 'package:cosmetic_frontend/blocs/product_characteristic/product_characteristic_bloc.dart';
import 'package:cosmetic_frontend/blocs/product_characteristic/product_characteristic_event.dart';
import 'package:cosmetic_frontend/blocs/product_characteristic/product_characteristic_state.dart';
import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class ProductCharacteristicScreen extends StatelessWidget {
  ProductCharacteristicScreen({Key? key, required this.productId}) : super(key: key);

  final String productId;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProductCharacteristicBloc>(context).add(ProductCharacteristicFetched(productId: productId));
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Đặc trưng sản phẩm"),
      ),
      body: SafeArea(
        child: BlocBuilder<ProductCharacteristicBloc, ProductCharacteristicState>(
          builder: (context, state) {
            switch (state.productCharacteristicStatus) {
              case ProductCharacteristicStatus.initial:
                return Center(child: CircularProgressIndicator());
              case ProductCharacteristicStatus.loading:
                return Center(child: CircularProgressIndicator());
              case ProductCharacteristicStatus.failure:
                return Center(child: Text('Failed'));
              case ProductCharacteristicStatus.success: {
                final productCharacteristic = state.productCharacteristic;
                final listCriteria = productCharacteristic?.listCriteria;
                final features = listCriteria?.map((e) => e.criteria).toList() ?? [];
                final subData = listCriteria?.map((e) => e.averagePoint).toList() ?? [];
                final data = [subData];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text("Số lượng đánh giá (${productCharacteristic?.totalReviews})", style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        // child: ScrollConfiguration(
                          // behavior: ScrollBehavior(), // ngăn strech effect
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(), // listview in SingleChildScrollView không thể cuộn cả 2 đồng thời được
                            separatorBuilder: (ctx, index){
                              return SizedBox(height: 12);
                            },
                            itemCount: listCriteria?.length ?? 0,
                            itemBuilder: (ctx, index) {
                              return IgnorePointer(
                                child: Container( // Màu nền
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    // Viền
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.withOpacity(
                                        0.2), // Bo tròn viền
                                  ),
                                  child: ListTile(
                                    leading: SizedBox(
                                      width: 40,
                                      child: FilledButton.tonal(
                                        onPressed: () {},
                                        child: Text("$index"),
                                        style: FilledButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(0)
                                        ),
                                      ),
                                    ),
                                    title: Text("${listCriteria?[index].criteria}"),
                                    subtitle: Wrap(
                                        spacing: 4,
                                        children: [
                                          StarList(rating: listCriteria?[index].averagePoint ?? 0),
                                          Text("${listCriteria?[index].averagePoint}")
                                        ]
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                      // ),
                      CharacteristicStatistics(features: features, data: data)
                    ],
                  ),
                );
              }

            }
          }
        )
      ),
    );
  }
}


class CharacteristicStatistics extends StatelessWidget {
  final List<String> features;
  final List<List<double>>data;

  CharacteristicStatistics({required this.features, required this.data});

  @override
  Widget build(BuildContext context) {
    const ticks = [1,2,3,4,5];

    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.white,
      child: RadarChart(
        ticks: ticks,
        features: features,
        data: data,
        reverseAxis: false,
        sides: features.length,
        featuresTextStyle: const TextStyle(color: Colors.black, fontSize: 14),

      ),
    );
  }
}