import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends  StatefulWidget {
  static const routeName='/edit-products';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
   final _priceFocusNode=FocusNode();
   final _descriptionFocusNode=FocusNode();
   final _imageUrlController=TextEditingController();
   final _imageUrlFocusnode=FocusNode();

   final _formkey=GlobalKey<FormState>();

   var _isinit=true;
   var _initValues={
     'title':'',
     'price':'',
     'imageUrl':'',
     'description':'',
   };

   var _editedProduct=Product(
       id:null,
     title: '',
     price: 0,
     description: '',
     imageUrl: '',
   );

   @override
  void dispose() {
     _priceFocusNode.dispose();
     _descriptionFocusNode.dispose();
     _imageUrlController.dispose();
     _imageUrlFocusnode.dispose();
     _imageUrlFocusnode.removeListener(_updateImageUrl);
    super.dispose();

  }

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusnode.addListener(_updateImageUrl);
    super.initState();

  }

  @override
  void didChangeDependencies() {
    if(_isinit){
      final _productId=ModalRoute.of(context).settings.arguments as String;
      if(_productId!=null){
        _editedProduct=Provider.of<Products>(context,listen: false).findById(_productId);
        _initValues={
          'title':_editedProduct.title,
          'price':_editedProduct.price.toString(),
          //'imageUrl':_editedProduct.imageUrl,
          'description':_editedProduct.description,
          'imageUrl':''
        };
        _imageUrlController.text=_editedProduct.imageUrl;
      }

    }
    _isinit=false;
    super.didChangeDependencies();
  }

  //to preview image set listener when we go to another field
  void _updateImageUrl(){
   if(!_imageUrlFocusnode.hasFocus){
     if(_imageUrlController.text.isEmpty ||
         (!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')) ||
         (!_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg'))
     ){
       return;
     }
     setState(() {

     });
   }
  }

  void _saveForm(){
    if(!_formkey.currentState.validate()){
      return;
    }
    _formkey.currentState.save();
    if(_editedProduct.id!=null){
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id,_editedProduct);
    }else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onSaved: (value){
                  _editedProduct=Product(
                      title: value,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                    id:_editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },//to change focus
              ),
              TextFormField(
                initialValue:  _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onSaved: (value){
                  _editedProduct=Product(
                      title: _editedProduct.title,
                      price: double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                    id:_editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Please enter a price.';
                  }
                  //if user inputs rather than number
                  if(double.tryParse(value)==null){
                    return 'Please enter a valid number';
                  }
                  if(double.parse(value)<=0){
                    return 'Please enetr number >0';
                  }
                  return null;
                },
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (value){
                  _editedProduct=Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      id:_editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Please enter a description.';
                  }
                  if(value.length<10){
                    return 'Should be atleast 10 characters';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8,right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty?Text('Enter a URL'):
                    FittedBox(
                      child: Image.network(_imageUrlController.text,fit: BoxFit.cover,),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusnode,
                      onFieldSubmitted: (_)=>_saveForm(),
                      onSaved: (value){
                        _editedProduct=Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: value,
                          id:_editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
