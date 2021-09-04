package roomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class RoomListMapTipPanel extends Sprite implements Disposeable
   {
      
      public static const FB_CHANGE:String = "fbChange";
       
      
      private var _bg:Scale9CornerImage;
      
      private var _listContent:VBox;
      
      private var _itemArray:Array;
      
      private var _cellWidth:int;
      
      private var _cellheight:int;
      
      private var _list:ScrollPanel;
      
      private var _value:int;
      
      public function RoomListMapTipPanel(param1:int, param2:int)
      {
         this._cellWidth = param1;
         this._cellheight = param2;
         super();
         this.init();
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function resetValue() : void
      {
         this._value = 10000;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.ddtroomList.RoomList.tipItemBg");
         this._bg.width = this._cellWidth;
         this._bg.height = 0;
         addChild(this._bg);
         this._listContent = new VBox();
         this._itemArray = [];
         this._list = UICreatShortcut.creatAndAdd("asset.ddtroomList.RoomListMapTipPanel.SrollPanel",this);
         this._list.setView(this._listContent);
      }
      
      public function addItem(param1:int) : void
      {
         var _loc2_:MapItemView = new MapItemView(param1,this._cellWidth,this._cellheight);
         _loc2_.addEventListener(MouseEvent.CLICK,this.__itemClick);
         this._listContent.addChild(_loc2_);
         this._itemArray.push(_loc2_);
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.RoomListMapTipPanel.BGSize");
         this._bg.width = _loc3_.x;
         this._bg.height = _loc3_.y;
         this._list.invalidateViewport();
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._value = (param1.target as MapItemView).id;
         dispatchEvent(new Event(FB_CHANGE));
         this.visible = false;
      }
      
      private function cleanItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemArray.length)
         {
            (this._itemArray[_loc1_] as MapItemView).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._itemArray[_loc1_] as MapItemView).dispose();
            _loc1_++;
         }
         this._itemArray = [];
      }
      
      public function dispose() : void
      {
         this.cleanItem();
         ObjectUtils.disposeObject(this._listContent);
         this._listContent = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
      }
   }
}
