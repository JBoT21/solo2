import 'package:flutter/material.dart';


void main(){
  runApp(MaterialApp(
    home: FormInputWidget(),
  ));
}



class FormInputWidget extends StatefulWidget {
  const FormInputWidget({super.key});

  @override
  State<FormInputWidget> createState() => _FormInputWidgetState();
}

final serviceSelected = <bool>[false, false, false];

class _FormInputWidgetState extends State<FormInputWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mealCostController = TextEditingController();
  int currentColorIndex = 0;

  final List<Color> backgroundColors = [
    Colors.white,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  final List<Color> foregroundColors = [
    Colors.black,
    Colors.white,
    Colors.white,
    Colors.black,
    Colors.white,
  ];

  void cycleColors() {
    setState(() {
      currentColorIndex =
          (currentColorIndex + 1) % backgroundColors.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors[currentColorIndex],
      appBar: AppBar(
          title: Text("Tip Calculator!"),
              backgroundColor: backgroundColors[currentColorIndex],
              foregroundColor: foregroundColors[currentColorIndex],

      ),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: cycleColors,
            child: Container(
                color: backgroundColors[currentColorIndex],
                width: double.infinity,
                height: double.infinity,
                child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text("Let's calculate your tip!",
            style: TextStyle(
              color: foregroundColors[currentColorIndex],
            ),
            ),
            TextFormField(
              controller: mealCostController,
              decoration: InputDecoration(
                  labelText: "How much did your meal cost?"
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter valid meal cost.";
                }
                if (double.tryParse(value) == null) {
                  return "Please enter a number";
                }
                if (double.tryParse(value)! <= 0){
                  return "Choose a valid cost above 0 dollars.";
                }
                return null;
              },
            ),

            ToggleButtons(
                selectedColor: Colors.black,
                isSelected: serviceSelected,
                onPressed: (index){
                  setState(() {
                    for (int i = 0; i < serviceSelected.length; i++) {
                      serviceSelected[i] = (i == index);
                    }
                  });
                },
                children: [
                  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Text('Average Service\n15%'),
                ),
                  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Text('Good Service\n18%'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.0),
                    child: Text('Excellent Service\n21%'),
                  ),
                  ]
              ),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  double mealCost = double.parse(mealCostController.text);
                  double tipPercent = 0.0;

                  if (serviceSelected[0]) {
                    tipPercent = 0.15;
                  } else if (serviceSelected[1]) {
                    tipPercent = 0.18;
                  } else if (serviceSelected[2]) {
                    tipPercent = 0.21;
                  }

                  double total = mealCost + (mealCost * tipPercent);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Total: \$${total.toStringAsFixed(2)}",
                      ),
                    ),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ]
        ),
      ),
    ),
        )
        );
  }
}


