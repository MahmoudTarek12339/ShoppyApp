import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/chip_data.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final double spacing = 8;
  List<ChoiceChipData> choiceChips=[
    ChoiceChipData(
      isSelected: true,
      selectedColor: Colors.blue,
      textColor: Colors.white,
      label: 'All',
    ),
    ChoiceChipData(
      isSelected: false,
      selectedColor: Colors.blue,
      textColor: Colors.white,
      label: 't-Shirts'
    ),
    ChoiceChipData(
      isSelected: false,
      selectedColor: Colors.blue,
      textColor: Colors.white,
      label: 'Shirts'
    ),
    ChoiceChipData(
      isSelected: false,
      selectedColor: Colors.blue,
      textColor: Colors.white,
      label: 'pants'
    ),
    ChoiceChipData(
      isSelected: false,
      selectedColor: Colors.blue,
      textColor: Colors.white,
      label: 'shorts',
    ),
    ChoiceChipData(
      isSelected: false,
      selectedColor: Colors.blue,
      textColor: Colors.white,
      label: 'accessories',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){},
      builder: (context,state){
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                buildChoiceChips(),
                SizedBox(
                  height: 25.0
                ),
                if(choiceChips[0].isSelected)
                  Container(
                  child: GridView.count(crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1/1.5,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(20,(index)=>buildProductItem()),
                  ),
                )
                else if(choiceChips[1].isSelected)
                  Container(
                    child: GridView.count(crossAxisCount: 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 1/1.5,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(8,(index)=>buildProductItem()),
                    ),
                  )
                else if(choiceChips[2].isSelected)
                  Container(
                      child: GridView.count(crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1/1.5,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(4,(index)=>buildProductItem()),
                      ),
                    )
                else if(choiceChips[3].isSelected)
                  Container(
                      child: GridView.count(crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1/1.5,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(2,(index)=>buildProductItem()),
                      ),
                    )
                else if(choiceChips[4].isSelected)
                  Container(
                      child: GridView.count(crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1/1.5,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(2,(index)=>buildProductItem()),
                      ),
                    )
                else if(choiceChips[5].isSelected)
                    Container(
                      child: GridView.count(crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1/1.5,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(2,(index)=>buildProductItem()),
                      ),
                    )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildProductItem() =>Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 10.0,
    shadowColor: Colors.white,
    child: Image(
      image: NetworkImage('https://i.pinimg.com/564x/e8/be/6e/e8be6e703137738190f71be515088fa0.jpg'),
      fit:BoxFit.cover,
    ),
  );

  Widget buildChoiceChips() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Wrap(
      runSpacing: spacing,
      spacing: spacing,
      children: choiceChips
          .map((choiceChip) => ChoiceChip(
        label: Text(choiceChip.label),
        labelStyle: TextStyle(color: Colors.white),
        onSelected: (isSelected) => setState(() {
          choiceChips = choiceChips.map((otherChip) {
            final newChip = otherChip.copy(isSelected: false);
            return choiceChip == newChip
                ? newChip.copy(isSelected: isSelected)
                : newChip;
          }).toList();
        }),
        selected: choiceChip.isSelected,
        selectedColor: Colors.deepOrange,
        backgroundColor: Colors.grey,

      )).toList(),
    ),
  );
}
