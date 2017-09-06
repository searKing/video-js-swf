
package com.videojs 
{   
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;

	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class BitmapBytes
	{   
		public static const IMAGE_TYPE_PNG:String = "png";
		public static const IMAGE_TYPE_JPG:String = "jpg";
		public static const IMAGE_TYPE_RGB:String = "rgb";
		public static function bitmapDataToDataURL(data:BitmapData, imageType:String = IMAGE_TYPE_PNG):String{   
			var bytes:ByteArray	= bitmapDataToByteArray(data, imageType);
			var base64:String 	= byteArrayToBase64(bytes);
			
			return base64ToDataUrl(base64, imageType);
			
		}
		
		// BitmapData ->	ByteArray	
		private static function bitmapDataToByteArray(data:BitmapData, imageType:String = IMAGE_TYPE_PNG):ByteArray{
			if(data == null){   
				throw new Error("data参数不能为空!");   
			}   
			
			var bytes:ByteArray;
			if(imageType.toUpperCase() == IMAGE_TYPE_PNG){
				bytes = PNGEncoder.encode(data);
				
			}else if (imageType.toUpperCase() == IMAGE_TYPE_JPG){
				var jpgCoder:JPGEncoder = new JPGEncoder();
				bytes = jpgCoder.encode(data);
				
			}else if(imageType.toUpperCase() == IMAGE_TYPE_RGB){
				bytes= data.getPixels(data.rect);   
				bytes.writeShort(data.width);   
				bytes.writeShort(data.height);   
				bytes.writeBoolean(data.transparent);   
				bytes.compress();   
			}else{
				throw new Error("imageType("+imageType+")参数非法!");   
			}
			
			return bytes;
		}
		
		private static function byteArrayToBase64(bytes:ByteArray):String{
			return Base64.encode(bytes);
		}
		
		private static function base64ToDataUrl(dataUrl:String, imageType:String = IMAGE_TYPE_PNG):String{
			
			return getDataUrlPrefix(imageType) + dataUrl;
		}
		
		
		
		private static function dataUrlToBase64(dataUrl:String):String{
			var prefixPattern:RegExp = /^data:image\/[a-z]*:base64,/; 
			dataUrl.replace(prefixPattern, "");
			return dataUrl;
		}
		
		private static function base64ToByteArray(base64:String):ByteArray{
			return Base64.decode(base64);
		}
		private static function byteArrayToBitmapData(bytes:ByteArray, imageType:String = IMAGE_TYPE_PNG):BitmapData{   
			if(bytes == null){   
				throw new Error("bytes参数不能为空!");   
			}   
			
			if(imageType.toUpperCase() != IMAGE_TYPE_RGB){
				throw new Error("imageType("+imageType+")参数只支持("+IMAGE_TYPE_RGB+")!");   
			}
			bytes.uncompress();   
			if(bytes.length <  6){   
				throw new Error("bytes参数为无效值!");   
			}              
			bytes.position = bytes.length - 1;   
			var transparent:Boolean = bytes.readBoolean();   
			bytes.position = bytes.length - 3;   
			var height:int = bytes.readShort();   
			bytes.position = bytes.length - 5;   
			var width:int = bytes.readShort();   
			bytes.position = 0;   
			var datas:ByteArray = new ByteArray();             
			bytes.readBytes(datas,0,bytes.length - 5);   
			var bmp:BitmapData = new BitmapData(width,height,transparent,0);   
			bmp.setPixels(new Rectangle(0,0,width,height),datas);   
			return bmp;   
		}   
		
		
		private static function getDataUrlPrefix(imageType:String = IMAGE_TYPE_PNG):String{
			
			if(imageType.toUpperCase() == IMAGE_TYPE_PNG){
				return "data:image/png;base64,";
				
			}else if(imageType.toUpperCase() == IMAGE_TYPE_JPG){
				var jpgCoder:JPGEncoder = new JPGEncoder();
				return "data:image/jpg;base64,";
				
			}else if(imageType.toUpperCase() == IMAGE_TYPE_RGB){
				return "data:image/jpg;rgb,"
			}else{
				throw new Error("imageType("+imageType+")参数非法!");   
			}
		}
		
		
		
		
		public function BitmapBytes(){   
			throw new Error("BitmapBytes类只是一个静态类!");   
		}   
	}
}