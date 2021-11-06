import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class GroceryItemScreen extends StatefulWidget
{
  // Callback that lets you know when a new item is created
  final Function(GroceryItem) onCreate;

  // Callback that returns the updated grocery item
  final Function(GroceryItem) onUpdate;

  // The grocery item that the user clicked
  final GroceryItem? originalItem;

  final bool isUpdating;

  const GroceryItemScreen({
    Key? key,
    required this.onCreate,
    required this.onUpdate,
    this.originalItem,
  })  : isUpdating = (originalItem != null),
        super(key: key);

  @override
  _GroceryItemScreenState createState() => _GroceryItemScreenState();
}

class _GroceryItemScreenState extends State<GroceryItemScreen>
{
  final _nameController = TextEditingController(); // controls the value
                                                  // displayed in a text field
  String _name = '';
  Importance _importance = Importance.low;
  DateTime _dueDate = DateTime.now(); // stores the current date and time
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Color _currentColor = Colors.green; // stores the color label
  int _currentSliderValue = 0; // stores the quantity of an item

  @override
  void initState()
  {
    final originalItem = widget.originalItem;
    if (originalItem != null)
    {
      // When the originalItem is not null, the user is editing
      // an existing item. In this case, you must configure the
      // widget to show the item’s values

      _nameController.text = originalItem.name;
      _name = originalItem.name;
      _currentSliderValue = originalItem.quantity;
      _importance = originalItem.importance;
      _currentColor = originalItem.color;
      final date = originalItem.date;
      _timeOfDay = TimeOfDay(hour: date.hour, minute: date.minute);
      _dueDate = date;
    }

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // TODO 24: Add callback handler
            },)
        ],

        elevation: 0.0,

        title: Text(
          'Grocery Item',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildNameField(),
            // TODO 14: Add Importance selection
            // TODO 15: Add date picker
            // TODO 16: Add time picker
            // TODO 17: Add color picker
            // TODO 18: Add slider
            // TODO: 19: Add Grocery Tile
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          'Item Name',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),

        TextField(

          controller: _nameController,

          cursorColor: _currentColor,

          decoration: InputDecoration(

            hintText: 'E.g. Apples, Banana, 1 Bag of salt',

            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImportanceField() {
    // 1
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2
        Text(
          'Importance',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        // 3
        Wrap(
          spacing: 10.0,
          children: [
            // 4
            ChoiceChip(
              // 5
              selectedColor: Colors.black,
              // 6
              selected: _importance == Importance.low,
              label: const Text(
                'low',
                style: TextStyle(color: Colors.white),
              ),
              // 7
              onSelected: (selected) {
                setState(() => _importance = Importance.low);
              },
            ),
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == Importance.medium,
              label: const Text(
                'medium',
                style: TextStyle(color: Colors.white),
              ),
              onSelected: (selected) {
                setState(() => _importance = Importance.medium);
              },
            ),
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == Importance.high,
              label: const Text(
                'high',
                style: TextStyle(color: Colors.white),
              ),
              onSelected: (selected) {
                setState(() => _importance = Importance.high);
              },
            ),
          ],
        )
      ],
    );
  }

// TODO: ADD buildDateField()

// TODO: Add buildTimeField()

// TODO: Add buildColorPicker()

// TODO: Add buildQuantityField()

}
