package petsBag.view.list
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import petsBag.event.PetItemEvent;
   import petsBag.view.item.PetSelectItem;
   
   public class PetInfoList extends Sprite implements Disposeable
   {
      
      public static const MIN_COUNT:int = 7;
       
      
      private var _list:VBox;
      
      private var _fightFlag:Bitmap;
      
      private var _itemList:Vector.<PetSelectItem>;
      
      private var _count:int;
      
      private var _items:Vector.<PetInfo>;
      
      private var _selectedIndex:int;
      
      public function PetInfoList(param1:int)
      {
         super();
         this._count = param1 < MIN_COUNT ? int(MIN_COUNT) : int(param1);
         this.init();
      }
      
      protected function init() : void
      {
         this._list = ComponentFactory.Instance.creat("petsBag.view.list.petInfoList.vbox");
         addChild(this._list);
         this._fightFlag = ComponentFactory.Instance.creat("asset.petsBag.petInfoList.fightFlag");
         this._fightFlag.visible = false;
         addChild(this._fightFlag);
         this._itemList = new Vector.<PetSelectItem>();
      }
      
      protected function clearItems() : void
      {
         var _loc1_:PetSelectItem = null;
         while(this._itemList && this._itemList.length > 0)
         {
            _loc1_ = this._itemList.shift();
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__click);
            if(this._list.contains(_loc1_))
            {
               this._list.removeChild(_loc1_);
            }
            _loc1_.dispose();
         }
         this._itemList = null;
      }
      
      protected function __click(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         var _loc2_:PetSelectItem = param1.currentTarget as PetSelectItem;
         if(_loc2_.info)
         {
            SoundManager.instance.play("008");
            this.selectedIndex = _loc2_.index;
         }
      }
      
      public function get items() : Vector.<PetInfo>
      {
         return this._items;
      }
      
      public function set items(param1:Vector.<PetInfo>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PetSelectItem = null;
         var _loc4_:PetInfo = null;
         this._items = param1;
         this._count = Math.max(this._count,this.items.length);
         if(this._itemList.length < this._count)
         {
            _loc2_ = this._itemList.length;
            while(_loc2_ < this._count)
            {
               _loc3_ = new PetSelectItem(_loc2_);
               _loc3_.addEventListener(MouseEvent.CLICK,this.__click);
               this._list.addChild(_loc3_);
               this._itemList.push(_loc3_);
               _loc2_++;
            }
         }
         this._fightFlag.visible = false;
         _loc2_ = 0;
         while(_loc2_ < this._count)
         {
            _loc4_ = _loc2_ < this._items.length ? this._items[_loc2_] : null;
            if(_loc4_ && _loc4_.Place == 0)
            {
               this._fightFlag.visible = true;
               this._fightFlag.x = this._itemList[_loc2_].x + 85;
               this._fightFlag.y = this._itemList[_loc2_].y - -2;
            }
            this._itemList[_loc2_].info = _loc2_ < this._items.length ? this._items[_loc2_] : null;
            _loc2_++;
         }
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         var _loc2_:PetSelectItem = null;
         this._selectedIndex = param1;
         for each(_loc2_ in this._itemList)
         {
            _loc2_.selected = this._selectedIndex == _loc2_.index;
         }
         dispatchEvent(new PetItemEvent(PetItemEvent.ITEM_CHANGE,this._itemList[this._selectedIndex].info));
      }
      
      public function dispose() : void
      {
         this.clearItems();
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeObject(this._fightFlag);
         this._fightFlag = null;
         if(this._items)
         {
            this._items.length = 0;
         }
         this._items = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
