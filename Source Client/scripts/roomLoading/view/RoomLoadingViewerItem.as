package roomLoading.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import game.GameManager;
   import room.model.RoomPlayer;
   import room.view.RoomViewerItem;
   
   public class RoomLoadingViewerItem extends Sprite implements Disposeable
   {
      
      private static const MAX_VIEWER:int = 2;
       
      
      private var _viewerItems:Vector.<RoomViewerItem>;
      
      public function RoomLoadingViewerItem()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         var _loc2_:int = 0;
         var _loc4_:RoomViewerItem = null;
         var _loc5_:Bitmap = null;
         this._viewerItems = new Vector.<RoomViewerItem>();
         var _loc1_:Vector.<RoomPlayer> = this.findViewers();
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc4_ = new RoomViewerItem(_loc1_[_loc2_].place);
            _loc4_.changeBg();
            this._viewerItems.push(_loc4_);
            this._viewerItems[_loc2_].loadingMode = true;
            this._viewerItems[_loc2_].info = _loc1_[_loc2_];
            this._viewerItems[_loc2_].mouseEnabled = this._viewerItems[_loc2_].mouseChildren = false;
            PositionUtils.setPos(this._viewerItems[_loc2_],"asset.roomLoading.ViewerItemPos_" + String(_loc2_));
            addChild(this._viewerItems[_loc2_]);
            _loc2_++;
         }
         var _loc3_:int = MAX_VIEWER;
         while(_loc3_ > _loc1_.length)
         {
            _loc5_ = ComponentFactory.Instance.creatBitmap("asset.roomloading.noViewer");
            PositionUtils.setPos(_loc5_,"asset.roomLoading.ViewerItemPos_" + (_loc3_ - 1).toString());
            addChild(_loc5_);
            _loc3_--;
         }
      }
      
      private function findViewers() : Vector.<RoomPlayer>
      {
         var _loc3_:RoomPlayer = null;
         var _loc1_:Array = new Array();
         if(GameManager.Instance.Current)
         {
            _loc1_ = GameManager.Instance.Current.roomPlayers;
         }
         var _loc2_:Vector.<RoomPlayer> = new Vector.<RoomPlayer>();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.isViewer)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function dispose() : void
      {
         var _loc1_:RoomViewerItem = null;
         for each(_loc1_ in this._viewerItems)
         {
            _loc1_.dispose();
            _loc1_ = null;
         }
         this._viewerItems = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
