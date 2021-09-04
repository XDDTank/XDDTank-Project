package store.view.Compose.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ComposeListInfo;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import store.view.Compose.ComposeController;
   import store.view.Compose.ComposeEvents;
   
   public class ComposeMiddelItem extends Sprite implements Disposeable
   {
       
      
      private var _num:int;
      
      private var _parent:int;
      
      private var _selected:Boolean;
      
      private var _bigItemDic:DictionaryData;
      
      private var _middleItemDic:DictionaryData;
      
      private var _smallItemDic:DictionaryData;
      
      private var _bg:ScaleFrameImage;
      
      private var _itemTextSelected:FilterFrameText;
      
      private var _itemText:FilterFrameText;
      
      private var _itemVbox:VBox;
      
      public function ComposeMiddelItem(param1:int, param2:int)
      {
         super();
         this._num = param1;
         this._parent = param2;
         this._selected = false;
         this._bigItemDic = ComposeController.instance.model.composeBigDic;
         this._middleItemDic = ComposeController.instance.model.composeMiddelDic;
         this._smallItemDic = ComposeController.instance.model.composeSmallDic;
         this.initView();
         this.initEvent();
      }
      
      public function get num() : int
      {
         return this._num;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this._bg.setFrame(!!param1 ? int(1) : int(2));
         this.selectText(param1);
         if(this._selected)
         {
            this.initFollowView();
         }
         else
         {
            this.removeFollowView();
         }
      }
      
      private function selectText(param1:Boolean) : void
      {
         this._itemTextSelected.visible = param1 == true;
         this._itemText.visible = param1 == false;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.composeItemsView.middle.bg");
         this._bg.setFrame(2);
         this._bg.buttonMode = true;
         addChild(this._bg);
         this._itemTextSelected = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.middleItem.text");
         this._itemText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.middleItem.text2");
         this._itemTextSelected.visible = false;
         this._itemText.visible = true;
         if(this._middleItemDic[this._bigItemDic[this._parent]][this._num] as ComposeListInfo)
         {
            this._itemTextSelected.text = this._itemText.text = this._middleItemDic[this._bigItemDic[this._parent]][this._num].Name;
         }
         else
         {
            this._itemTextSelected.text = this._itemText.text = this._middleItemDic[this._bigItemDic[this._parent]][this._num];
         }
         addChild(this._itemTextSelected);
         addChild(this._itemText);
      }
      
      private function initFollowView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ComposeSmallItem = null;
         this._itemVbox = new VBox();
         if(this._smallItemDic[this._bigItemDic[this._parent]][this._num])
         {
            _loc1_ = 0;
            while(_loc1_ < this._smallItemDic[this._bigItemDic[this._parent]][this._num].length)
            {
               _loc2_ = new ComposeSmallItem(_loc1_,this._num,this._parent);
               if(this._selected && ComposeController.instance.model.getSelectedPageSmall(this._parent) == _loc1_ && ComposeController.instance.model.getSelectedPageSmallToMiddle(this._parent) == this._num)
               {
                  _loc2_.selected = true;
               }
               this._itemVbox.addChild(_loc2_);
               this._itemVbox.spacing = -18;
               _loc1_++;
            }
         }
         PositionUtils.setPos(this._itemVbox,"ddtstore.StoreIIComposeBG.comoseMiddleItem.vbox.pos");
         addChild(this._itemVbox);
      }
      
      private function removeFollowView() : void
      {
         if(this._itemVbox)
         {
            this._itemVbox.disposeAllChildren();
            ObjectUtils.disposeObject(this._itemVbox);
            this._itemVbox = null;
         }
      }
      
      private function initEvent() : void
      {
         this._bg.addEventListener(MouseEvent.CLICK,this.__clickHandle);
      }
      
      private function __clickHandle(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._selected = !!this._selected ? Boolean(false) : Boolean(true);
         if(this.selected)
         {
            ComposeController.instance.model.saveSeletedPageMiddle(this._parent,this._num);
            dispatchEvent(new ComposeEvents(ComposeEvents.CLICK_MIDDLE_ITEM,this._num));
         }
         else
         {
            ComposeController.instance.model.saveSeletedPageMiddle(this._parent,-2);
            dispatchEvent(new ComposeEvents(ComposeEvents.CLICK_MIDDLE_ITEM,-1));
         }
      }
      
      private function removeEvent() : void
      {
         this._bg.removeEventListener(MouseEvent.CLICK,this.__clickHandle);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeFollowView();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._itemTextSelected);
         this._itemTextSelected = null;
         ObjectUtils.disposeObject(this._itemText);
         this._itemText = null;
      }
   }
}
