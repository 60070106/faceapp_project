<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

use App\Models\Picture;

use Validator;

class PictureController extends Controller
{
    public function getallpictures()
    {
        return response() -> json(Picture::get(), 200);
    }

    public function insert(Request $request)
    {
        print_r($request->input());
        $picture = new Picture;
        $fileName = $request->input('name');
        $image = $request->input('img');

        $picture->name = $fileName;
        $picture->img = $image;

        $data = 'data:image/png;base64,'.$image;
        $source = fopen($data, 'r');
        $destination = fopen('image/'.time().'.jpeg' , 'w');

        stream_copy_to_stream($source, $destination);
        fclose($source);
        fclose($destination);


        $picture->save();

        // return $data;
        // return $image;
    }
}
