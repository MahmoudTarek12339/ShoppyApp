
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/product_model.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VirtualFittingScreen extends StatefulWidget {
  final int index;
  final ProductModel product;
  final int selectedColor;
  const VirtualFittingScreen({required this.index,required this.product,required this.selectedColor});

  @override
  State<VirtualFittingScreen> createState() => _VirtualFittingScreenState();
}

class _VirtualFittingScreenState extends State<VirtualFittingScreen> {
  List<String?> virImage=[];
  List<String?> virCategory=[];

  @override
  void initState() {
    super.initState();
    ShoppyCubit.get(context).lowSelection=-1;
    ShoppyCubit.get(context).upSelection=-1;
    ShoppyCubit.get(context).virResult=null;
    if(widget.product.virtualImage.containsKey(widget.selectedColor.toString())){
      virImage.add(widget.product.virtualImage[widget.selectedColor.toString()]);
      virCategory.add(widget.product.category);
    }
    ShoppyCubit.get(context).cart.forEach((element) {
      if(element.productUid!=widget.product.productUid) {
        ProductModel prod = ShoppyCubit
            .get(context)
            .products
            .where((element1) => element.productUid == element1.productUid)
            .first;
        String? c = prod.virtualImage[element.color];
        if (c != null) {
          virImage.add(c);
          virCategory.add(prod.category);
        }
      }
    });
    print(virImage.length);
    print(virCategory.length);
    if(virImage.length==1){
      ProductModel? prod =getRandomProduct(virCategory[0]);
      if(prod!=null){
        String img=prod.virtualImage.values.first;
        virImage.add(img);
        virCategory.add(prod.category);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit, ShoppyStates>(
        builder: ((context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                if(ShoppyCubit.get(context).upSelection!=-1&&ShoppyCubit.get(context).lowSelection!=-1)
                  IconButton(onPressed: (){
                    ShoppyCubit.get(context).sendToVirtual(
                        selectedImage: virImage[ShoppyCubit.get(context).lowSelection].toString(),
                        selectedImage2: virImage[ShoppyCubit.get(context).upSelection].toString(),
                        category: virCategory[ShoppyCubit.get(context).lowSelection].toString(),
                        category2: virCategory[ShoppyCubit.get(context).upSelection].toString(),
                        index: widget.index
                    );
                  },
                  icon: Icon(Icons.done,color: Theme.of(context).canvasColor,))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      ShoppyCubit.get(context).changeVisibilityVirtual();
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: ShoppyCubit.get(context).virResult!=null?
                       Image.file(ShoppyCubit.get(context).virResult!)
                        :Image.asset(
                      'assets/skins/model${widget.index + 1}.png',
                      height: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  if (ShoppyCubit.get(context).vis)
                    Positioned(
                      bottom:100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 120,
                          width:320,
                          child: virImage.isNotEmpty?
                             ListView.separated(
                          scrollDirection:Axis.horizontal,
                          itemBuilder: (context, index) => productItem(
                            context: context,
                            image: virImage[index]??'',
                            index: index,
                            category: virCategory[index]
                          ),
                          separatorBuilder: (context, index) => SizedBox(width: 15,),
                          itemCount: virImage.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                        )
                            :Container(
                            color: Colors.grey.withOpacity(0.5),
                            child: Center(child: Text(
                              'Your Cart is Empty',
                              style: Theme.of(context).textTheme.bodyText1,
                            )),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        }),
        listener: (context, state) {
          if(state is ShoppySendVirtualLoadingState){
            AlertDialog alertUpload = AlertDialog(
              title: Text(
                "Processing",
                style:Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).focusColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "${AppLocalizations.of(context)!.yourDataIsBeingProcessed}",
                      style:Theme.of(context).textTheme.subtitle1
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CircularProgressIndicator(color: Theme.of(context).focusColor,)
                ],
              ),
              backgroundColor: Theme.of(context).cardColor,
              actions: [
                TextButton(
                  child: Text(
                    '${AppLocalizations.of(context)!.cancel}',
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertUpload;
              },
            );
          }
          else if(state is ShoppyGetVirtualSuccessState){
          Navigator.pop(context);
          }
          else if(state is ShoppyGetVirtualErrorState){
          Navigator.pop(context);
          defaultSnackBar(context: context, title: state.error, color: Colors.red);
          }
        });

  }
  Widget productItem({required String image,required context,required int index, required category}) {
    bool low=(category=='Pants'||category=='Shorts');

    return InkWell(
      onTap: () {
        ShoppyCubit.get(context).changeSelectionVirtual(index,category);
      },
      child: Container(
        height: 150.0,
        width: 120.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            color: Colors.white,
            border: low&&ShoppyCubit.get(context).lowSelection==index?
            Border.all(color:Colors.greenAccent,width: 5)
                :!low&&ShoppyCubit.get(context).upSelection==index?
            Border.all(color:Colors.teal,width: 5)
                :null,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3.0,
                  blurRadius: 5.0),
            ]),
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.network(
            image,
            fit: BoxFit.fitHeight,
            loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
                ? child
                : Center(child: CircularProgressIndicator()),
            errorBuilder: (context, error, stackTrace) =>
            new Image.asset('assets/images/default_login2.jpg'),
          ),
        ),
      ),
    );
  }


  ProductModel? getRandomProduct(String? virCategory) {
    if(virCategory=='Pants'||virCategory=='Shorts'){
      List<ProductModel> lst=  ShoppyCubit.get(context).products.where((element) {
        return (element.category=='T-shirts'||element.category=='Shirts') && element.virtualImage.keys.isNotEmpty;
      }).toList();
      if(lst.isNotEmpty)
        return lst.first;
      else
        return null;
    }
    else{
      List<ProductModel> lst= ShoppyCubit.get(context).products.where((element) {
        return (element.category=='Pants'||element.category=='Shorts') && element.virtualImage.keys.isNotEmpty;
      }).toList();
      if(lst.isNotEmpty)
        return lst.first;
      else
        return null;
    }
  }

}
