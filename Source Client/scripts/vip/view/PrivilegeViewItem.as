package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class PrivilegeViewItem extends Sprite implements Disposeable
   {
      
      public static const TRUE_FLASE_TYPE:int = 0;
      
      public static const UNIT_TYPE:int = 1;
      
      public static const GRAPHICS_TYPE:int = 2;
      
      public static const NORMAL_TYPE:int = 3;
       
      
      private var _bg:Image;
      
      private var _titleTxt:FilterFrameText;
      
      private var _content:Vector.<String>;
      
      private var _displayContent:Vector.<DisplayObject>;
      
      private var _itemType:int;
      
      private var _itemIndex:int;
      
      private var _extraDisplayObject;
      
      private var _extraDisplayObjectList:Vector.<DisplayObject>;
      
      private var _interceptor:Function;
      
      private var _analyzeFunction:Function;
      
      private var _crossFilter:String = "0";
      
      public function PrivilegeViewItem(param1:int = 1, param2:int = 3, param3:* = null)
      {
         super();
         this._itemIndex = param1;
         this._itemType = param2;
         this._extraDisplayObject = param3;
         this._extraDisplayObjectList = new Vector.<DisplayObject>();
         this._analyzeFunction = this.analyzeContent;
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemBg");
         this._bg.visible = this._itemIndex % 2 == 0 ? Boolean(true) : Boolean(false);
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemTitleTxt");
         addChild(this._bg);
         addChild(this._titleTxt);
      }
      
      protected function analyzeContent(param1:Vector.<String>) : Vector.<DisplayObject>
      {
         var _loc4_:String = null;
         var _loc5_:FilterFrameText = null;
         var _loc6_:Image = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:Sprite = null;
         var _loc9_:DisplayObject = null;
         var _loc2_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("vip.levelPrivilegeItemTxtStartPos");
         for each(_loc4_ in param1)
         {
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemTxt");
            _loc5_.text = _loc4_;
            PositionUtils.setPos(_loc5_,_loc3_);
            _loc3_.x += _loc5_.width + 15;
            if(_loc4_ == this._crossFilter)
            {
               _loc6_ = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross");
               _loc6_.x = _loc5_.width - _loc6_.width + _loc5_.x;
               _loc6_.y = _loc5_.y;
               _loc2_.push(_loc6_);
            }
            else
            {
               switch(this._itemType)
               {
                  case TRUE_FLASE_TYPE:
                     _loc7_ = _loc4_ == "1" ? ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.Tick") : ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross");
                     _loc7_.x = _loc5_.width - _loc7_.width + _loc5_.x;
                     _loc7_.y = _loc5_.y;
                     _loc2_.push(_loc7_);
                     continue;
                  case UNIT_TYPE:
                     _loc5_.text += String(this._extraDisplayObject);
                     break;
                  case GRAPHICS_TYPE:
                     _loc8_ = new Sprite();
                     _loc9_ = ComponentFactory.Instance.creatBitmap(this._extraDisplayObject);
                     this._extraDisplayObjectList.push(_loc9_);
                     this._extraDisplayObjectList.push(_loc5_);
                     _loc5_.width -= _loc9_.width;
                     _loc9_.x = _loc5_.width + _loc5_.x;
                     _loc9_.y = _loc5_.y;
                     _loc8_.addChild(_loc5_);
                     _loc8_.addChild(_loc9_);
                     _loc2_.push(_loc8_);
                     continue;
               }
               _loc2_.push(_loc5_);
            }
         }
         return _loc2_;
      }
      
      public function set crossFilter(param1:String) : void
      {
         this._crossFilter = param1;
      }
      
      public function set contentInterceptor(param1:Function) : void
      {
         this._interceptor = param1;
      }
      
      public function set itemTitleText(param1:String) : void
      {
         this._titleTxt.text = param1;
      }
      
      public function set analyzeFunction(param1:Function) : void
      {
         this._analyzeFunction = param1;
      }
      
      public function set itemContent(param1:Vector.<String>) : void
      {
         this._content = param1;
         this._displayContent = this._analyzeFunction(this._content);
         this.updateView();
      }
      
      private function updateView() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this._displayContent)
         {
            addChild(_loc1_);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:DisplayObject = null;
         if(this._displayContent != null)
         {
            for each(_loc2_ in this._displayContent)
            {
               ObjectUtils.disposeObject(_loc2_);
            }
         }
         this._displayContent = null;
         for each(_loc1_ in this._extraDisplayObjectList)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._extraDisplayObjectList = null;
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._titleTxt);
         this._bg = null;
         this._titleTxt = null;
      }
   }
}
