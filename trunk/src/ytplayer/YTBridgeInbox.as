package ytplayer
{
	import flash.net.LocalConnection;
	
	internal class YTBridgeInbox {
		
		private static const INBOX_NAME:String = "YTBHOSTCENTRAL";
		private var inbox:LocalConnection = new LocalConnection();
		
		public function YTBridgeInbox () {
			inbox.client = this;
			inbox.connect( INBOX_NAME );
		}
		
		public function onChannelOpen (localConnectionName:String):void {
			YTPlayer.onChannelOpen( localConnectionName );
		}
	}
}