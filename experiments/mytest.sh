if [ -e "$1" ]
then
  basedir=$(dirname $(readlink -f "$1"))
  filename=${1##*/}
  extension=${filename##*.}
  filename=${filename%%.*}
  echo $filename
  echo $extension
  echo $basedir
else
  echo "movie file not existing"
fi

myImgDir="$basedir/my$filename"
echo $myImgDir
if [ ! -d "$myImgDir" ]
then
  mkdir $myImgDir
  ffmpeg -i "$1" -f image2 "$myImgDir/"video-frame%05d.jpg
  echo "===============video converted to frames================="
fi

cd ~/monodepth2
#python test_simple.py --image_path $myImgDir --model_name mono+stereo_640x192

myVideo="$myImgDir.$extension"
#ffmpeg -i "$myImgDir/"video-frame%05d_disp.jpeg "$myImgDir.$extension"
ffmpeg  -f image2 -framerate 30 -i "$myImgDir/"video-frame%05d.jpg $myVideo
echo "=================frames converted to video==================="
ffmpeg -i $1 -i $myVideo -filter_complex vstack=inputs=2 "$basedir/final.MOV"
echo "==================videos stacked========================="