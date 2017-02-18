package laya.device.geolocation
{
	public class GeolocationInfo
	{
		private var pos:*;
		private var coords:*;
		
		public function setPosition(pos:*):void
		{
			this.pos = pos;
			coords = pos.coords;
		}
		
		public function get latitude():Number
		{
			return coords.latitude;
		}
		
		public function get longitude():Number
		{
			return coords.longitude;
		}
		
		public function get altitude():Number
		{
			return coords.altitude;
		}
		
		public function get accuracy():Number
		{
			return coords.accuracy;
		}
		
		public function get altitudeAccuracy():Number
		{
			return coords.altitudeAccuracy;
		}
		
		public function get heading():Number
		{
			return coords.heading;
		}
		
		public function get speed():Number
		{
			return coords.speed;
		}
		
		public function get timestamp():Number
		{
			return pos.timestamp;
		}
	}
}