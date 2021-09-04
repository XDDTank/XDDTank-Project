package platformapi.tencent.view.closeFriend
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CloseFriendListView extends Sprite implements Disposeable
   {
      
      private static const MAXITEM:int = 6;
       
      
      private var _bg:Bitmap;
      
      private var _listView:VBox;
      
      private var _playerList:Array;
      
      private var _items:Vector.<CloseFriendItemFrame>;
      
      private var _selectedItem:CloseFriendItemFrame;
      
      public function CloseFriendListView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.IM.CloseFriend.listBg");
         addChild(this._bg);
         this._listView = ComponentFactory.Instance.creatComponentByStylename("IM.CloseFriend.vBox");
         addChild(this._listView);
         this._items = new Vector.<CloseFriendItemFrame>();
      }
      
      public function clearList() : void
      {
         if(!this._items)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].removeEventListener(MouseEvent.CLICK,this.__onItemClick);
            ObjectUtils.disposeObject(this._items[_loc1_]);
            this._items[_loc1_] = null;
            _loc1_++;
         }
         this._items = new Vector.<CloseFriendItemFrame>();
         this._playerList = [];
         this._selectedItem = null;
      }
      
      public function get playerList() : Array
      {
         return this._playerList;
      }
      
      public function set playerList(param1:Array) : void
      {
         var _loc4_:CloseFriendItemFrame = null;
         this.clearList();
         this._playerList = param1;
         if(!this._playerList || this._playerList.length == 0)
         {
            return;
         }
         var _loc2_:int = this._playerList.length > MAXITEM ? int(MAXITEM) : int(this._playerList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._playerList[_loc3_])
            {
               _loc4_ = new CloseFriendItemFrame();
               _loc4_.info = this._playerList[_loc3_];
               _loc4_.addEventListener(MouseEvent.CLICK,this.__onItemClick);
               this._listView.addChild(_loc4_);
               this._items.push(_loc4_);
               if(_loc3_ == 0)
               {
                  this.selectedItem = _loc4_;
               }
            }
            _loc3_++;
         }
      }
      
      private function __onItemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:CloseFriendItemFrame = param1.currentTarget as CloseFriendItemFrame;
         if(!_loc2_.selected)
         {
            this.selectedItem = _loc2_;
         }
      }
      
      public function get selectedItem() : CloseFriendItemFrame
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(param1:CloseFriendItemFrame) : void
      {
         var _loc2_:CloseFriendItemFrame = null;
         if(this._selectedItem != param1)
         {
            _loc2_ = this._selectedItem;
            this._selectedItem = param1;
            if(this._selectedItem)
            {
               this._selectedItem.selected = true;
            }
            if(_loc2_)
            {
               _loc2_.selected = false;
            }
         }
      }
      
      public function dispose() : void
      {
         this.clearList();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(this._listView)
         {
            this._listView.dispose();
         }
         this._listView = null;
         if(this.selectedItem)
         {
            this.selectedItem.dispose();
         }
         this.selectedItem = null;
         this._items = null;
      }
   }
}
