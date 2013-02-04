﻿package  {
	
	import flash.display.MovieClip;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.events.Event;
	
	public class jQPlayer extends MovieClip {
		
		private var _stream:NetStream;
		private var _video:Video;
		private var _draw:Draw = new Draw();
		private var _util:Util;
		private var _streamed:Boolean;
				
		public function jQPlayer() {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			_util = new Util(this.root);
			var connection:NetConnection = new NetConnection();
			connection.connect(null);
			
			_stream = new NetStream(connection);
			
			setupVideo();
			//createControls();
			
			_stream.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			
			addEventListener(Event.ADDED_TO_STAGE, bindEvents);
		}
		
		private function setupVideo() {
			_video = new Video();
			addChild(_video);
			
			ExternalInterface.call( "console.log" , "Stage: " + stage.width);
			
			_video.attachNetStream(_stream);
			/*_video.width = stage.stageWidth;
			_video.height = stage.stageHeight;*/
		}
		
		private function onStatus(event:NetStatusEvent):void {
			if (_video.videoWidth > 0 && _video.width != _video.videoWidth) {
				_video.width = _video.videoWidth;
				_video.height = _video.videoHeight;
				
				var x = stage.stageWidth/2 - _video.videoWidth/2;
				var y = stage.stageHeight/2 - _video.videoHeight/2;
				
				if (x > 0) {
					_video.x = x;
				}
				
				if (y > 0) {
					_video.y = y;
				}
			}
		}
		
		private function playVideo():void {
			if (_streamed) {
				ExternalInterface.call( "console.log" , "Resume Video");
				_stream.resume();
			}
			else {
				ExternalInterface.call( "console.log" , "Play Video");
				_stream.play(_util.getFlashVar('video'));
				_streamed = true;
			}
		}
		
		private function pauseVideo():void {
			ExternalInterface.call( "console.log" , "Pause Video");
			_stream.pause();
		}
		
		/*private function createControls() {
			var width = 200;
			var height = 24;
			var x = stage.width/2 - width/2;
			var y = stage.height - height;
			var square = _draw.square(width, height, 0, null, 0xFF0000, x, y);
			
			//square.addEventListener(MouseEvent.CLICK, playVideos);
			
			addChild(square);
		}*/
		
		private function bindEvents(ev:Event):void {
			ExternalInterface.call( "console.log" , "Hey! I'm tracing from External!");
			ExternalInterface.marshallExceptions = true;
			ExternalInterface.addCallback("play", playVideo);
			ExternalInterface.addCallback("pause", pauseVideo);
		}
	}
}