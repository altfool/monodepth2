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
fi

ffmpeg -i "$1" -f image2 "$myImgDir/"video-frame%05d.jpg

python test_simple.py --image_path $myImgDir --model_name mono+stereo_640x192
