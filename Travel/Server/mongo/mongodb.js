const mongoose= require('mongoose');

mongoose.connect('mongodb://localhost:27017/traveldb')
.then(()=>{
    console.log('Mongo connected successfully');
}).catch((err)=>{
    console.log(err);
})

const travelSchema= new mongoose.Schema({
    name:{
        type:String,
        required:true
    },
    placeDesc:{
        type:String,
        required:true
    }
})

const travel=  mongoose.model('Travel',travelSchema)
 module.exports= travel;