package store.view.Compose.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SavePointManager;
   import flash.display.Sprite;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import store.view.Compose.ComposeController;
   import store.view.Compose.ComposeEvents;
   import store.view.Compose.ComposeType;
   
   public class ComposeItemsView extends Sprite implements Disposeable
   {
       
      
      private var _bigItemDic:DictionaryData;
      
      private var _middelItemDic:DictionaryData;
      
      private var _currentType:int;
      
      private var _itemArr:Array;
      
      private var _bg:Scale9CornerImage;
      
      private var _itemList:Array;
      
      private var _pos1:Point;
      
      public function ComposeItemsView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      private function initData() : void
      {
         this._bigItemDic = ComposeController.instance.model.composeBigDic;
         this._middelItemDic = ComposeController.instance.model.composeMiddelDic;
         this._currentType = ComposeType.EQUIP;
         ComposeController.instance.model.resetseletectedPage();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.composeItemsView.bg");
         addChild(this._bg);
         this._pos1 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.composeItemsView.pos1");
      }
      
      private function drawItems() : void
      {
         var _loc2_:ComposeBigItem = null;
         this._itemArr = new Array();
         var _loc1_:int = 1;
         while(_loc1_ <= this._bigItemDic.length)
         {
            _loc2_ = new ComposeBigItem(_loc1_);
            if(_loc1_ == this._currentType)
            {
               _loc2_.selected = true;
            }
            _loc2_.addEventListener(ComposeEvents.CLICK_BIG_ITEM,this.__bigItemClick);
            addChild(_loc2_);
            this._itemArr.push(_loc2_);
            if(SavePointManager.Instance.isInSavePoint(26) && !ComposeController.instance.model.composeSuccess)
            {
               if(_loc1_ == ComposeType.EQUIP)
               {
                  _loc2_.enable = true;
               }
               else
               {
                  _loc2_.enable = false;
               }
            }
            _loc1_++;
         }
         this.setPos();
      }
      
      private function setPos() : void
      {
         if(this._itemArr[0])
         {
            this._itemArr[0].x = this._pos1.x;
            this._itemArr[0].y = -8;
         }
         var _loc1_:int = 1;
         while(_loc1_ < this._itemArr.length)
         {
            if(this._itemArr[_loc1_ - 1].height > this._pos1.y)
            {
               this._itemArr[_loc1_].y = this._itemArr[_loc1_ - 1].y + this._pos1.y + 22;
            }
            else
            {
               this._itemArr[_loc1_].y = this._itemArr[_loc1_ - 1].y + this._itemArr[_loc1_ - 1].height + 4;
            }
            this._itemArr[_loc1_].x = this._pos1.x;
            _loc1_++;
         }
      }
      
      private function __bigItemClick(param1:ComposeEvents) : void
      {
         var _loc2_:ComposeBigItem = param1.currentTarget as ComposeBigItem;
         this._currentType = _loc2_.num;
         this.updateBigitem();
      }
      
      private function updateBigitem() : void
      {
         this.clearItems();
         this.drawItems();
      }
      
      private function initEvent() : void
      {
         ComposeController.instance.model.addEventListener(ComposeEvents.GET_SKILLS_COMPLETE,this.__getSkillsComplete);
      }
      
      private function clearItems() : void
      {
         var _loc1_:ComposeBigItem = null;
         if(this._itemArr && this._itemArr.length > 0)
         {
            for each(_loc1_ in this._itemArr)
            {
               _loc1_.removeEventListener(ComposeEvents.CLICK_BIG_ITEM,this.__bigItemClick);
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
            }
            this._itemArr = null;
         }
      }
      
      private function __getSkillsComplete(param1:ComposeEvents) : void
      {
         this.updateBigitem();
      }
      
      private function removeEvents() : void
      {
         ComposeController.instance.model.removeEventListener(ComposeEvents.GET_SKILLS_COMPLETE,this.__getSkillsComplete);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this.clearItems();
         if(this._itemList)
         {
            ObjectUtils.disposeObject(this._itemList);
            this._itemList = null;
         }
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
      }
   }
}
