const express= require('express');
const app= express();
const cors = require('cors');

PORT=process.env.PORT || 5001;
const travel = require('./mongo/mongodb')

app.use(express.json())
app.use(express.urlencoded({extended:false}))
app.use(cors());



app.get('/blogs',async(req,res)=>{
try {
        const blogs= await travel.find({})
        res.status(200).json(blogs)
    
} catch (error) {
    res.status(500).json({error:error.msg})

}})

app.get('/blogs/:id',async(req,res)=>{
    try {
        const{id}=req.params
        const blog= await travel.findById(id);
        res.status(200).json(blog)
    } catch (error) {
        res.status(500).json({error:error.msg})

    }
})

app.post('/blogs',async(req,res)=>{
    try {
       
        const blog= await travel.create(req.body)
        res.status(201).json(blog)
    } catch (error) {
       
        res.status(500).json({error:error.msg})
    }
})

app.put('/blogs/:id',async(req,res)=>{
    try {
            const {id}=req.params
            const blog= await travel.findByIdAndUpdate(id, req.body);
            if(!blog){
                return res.status(404).json({msg:`cannot find any product with ${id}`})
            }
            const updBlog=await travel.findById(id)
            res.status(200).json(updBlog);
        
    } catch (error) {
        res.status(500).json({error:error.msg})

    }
})

app.delete('/blogs/:id',async(req,res)=>{
    try {
        const {id}=req.params
        const blog=await travel.findByIdAndDelete(id)
        if(!blog){
            return res.status(404).json({msg:`cannot find any product with ${id}`})
        }
        res.status(200).json(blog);


    } catch (error) {
        
    }
})

app.listen(5001,()=>{
    console.log(`The Node is running on Port ${PORT}` );
})