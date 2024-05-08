import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  String dropdownvalue = '0-5';

  // List of items in our dropdown menu
  var items = [
    '0-5',
    '5-10',
    '10-15',
    '15-20',
    '20-25',
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      if(categoryController.categoryList != null && categoryController.categoryList!.isEmpty){
        return const SizedBox() ;
      }else{
        if(categoryController.categoryList != null){
          return Center(
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric( vertical:Dimensions.paddingSizeDefault),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('all_categories'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                          SizedBox(width:Dimensions.paddingSizeLarge),
                          DropdownButton(

                            // Initial Value
                            value: dropdownvalue,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {

                               setState(() {
                                 dropdownvalue = newValue!;
                               }

                               );
                            },
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {

                              Get.toNamed(RouteHelper.getCategoryProductRoute(
                                  categoryController.categoryList![0].id!,
                                  categoryController.categoryList![0].name!,
                                  0.toString()
                              ));
                            },
                            hoverColor: Theme.of(context).primaryColor.withOpacity(0.05),
                            child: Text('see_all'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                              decoration: TextDecoration.underline,
                              color:Get.isDarkMode ?Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6) : Theme.of(context).colorScheme.primary,
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : ResponsiveHelper.isTab(context) ? 6 : 4,
                          crossAxisSpacing: Dimensions.paddingSizeSmall,
                          mainAxisSpacing: Dimensions.paddingSizeSmall,
                          childAspectRatio: ResponsiveHelper.isDesktop(context) ? 1 : 1,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoryController.categoryList!.length > 8 ? 8 : categoryController.categoryList!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.toNamed(RouteHelper.getCategoryProductRoute(
                                  categoryController.categoryList![index].id!,
                                  categoryController.categoryList![index].name!,
                                  index.toString()
                              ));
                            },

                            child: Container(
                              padding: const EdgeInsets.only(top : Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hoverColor,
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault), ),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      child: CustomImage(
                                        image: '${Get.find<SplashController>().configModel.content!.imageBaseUrl}/category/${categoryController.categoryList![index].image}',
                                        fit: BoxFit.contain,
                                        height: ResponsiveHelper.isMobile(context)?50:ResponsiveHelper.isTab(context)?60:80,
                                        width: ResponsiveHelper.isMobile(context)?50:ResponsiveHelper.isTab(context)?60:80,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all( Dimensions.paddingSizeExtraSmall),
                                      child: Text(categoryController.categoryList![index].name!,
                                        style: ubuntuRegular.copyWith(fontSize: MediaQuery.of(context).size.width<300?Dimensions.fontSizeExtraSmall:Dimensions.fontSizeSmall),
                                        maxLines: MediaQuery.of(context).size.width<300?1:2,textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ]),
                            ),
                          );
                        },
                      ) ,
                    ]),
              ),
            ),
          );
        }else{
          return WebCategoryShimmer(categoryController: categoryController);
        }
      }
    });
  }
}



class WebCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  final bool? fromHomeScreen;

  const WebCategoryShimmer({super.key, required this.categoryController, this.fromHomeScreen=true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(
          children: [
            if(fromHomeScreen!)const SizedBox(height: Dimensions.paddingSizeLarge,),
            if(fromHomeScreen!)Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                height: 30,
                width: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: Get.isDarkMode?null:[BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
                  ),
                child: Center(child: Container(
                  height: ResponsiveHelper.isMobile(context)?10:ResponsiveHelper.isTab(context)?15:20,
                  color: Theme.of(context).shadowColor
                  ,
                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                ),),
              ),
                Container(
                  height: 30,
                  width: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: Get.isDarkMode? null :[BoxShadow(color: Colors.grey[300]!, blurRadius: 10, spreadRadius: 1)],
                    ),
                  child: Center(child: Container(
                    height: ResponsiveHelper.isMobile(context)?10:ResponsiveHelper.isTab(context)?15:20,
                    color: Theme.of(context).shadowColor,
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  ),),
                )
            ],),
            if(fromHomeScreen! && !ResponsiveHelper.isMobile(context))const SizedBox(height: Dimensions.paddingSizeSmall,),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: Get.isDarkMode?null:[BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
                    ),
                  margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                  child: Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                      Container(
                        height: ResponsiveHelper.isMobile(context)?28:ResponsiveHelper.isTab(context)?40:60,
                        width: ResponsiveHelper.isMobile(context)?28:ResponsiveHelper.isTab(context)?40:60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).shadowColor
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                        height: ResponsiveHelper.isMobile(context)?10:ResponsiveHelper.isTab(context)?15:20,
                        color: Theme.of(context).shadowColor,
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      ),
                    ]),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : ResponsiveHelper.isTab(context) ? 6 : 4,
                  crossAxisSpacing: Dimensions.paddingSizeDefault,
                  mainAxisSpacing: Dimensions.paddingSizeDefault,
                  childAspectRatio: ResponsiveHelper.isDesktop(context) ? 1 : 0.85,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
