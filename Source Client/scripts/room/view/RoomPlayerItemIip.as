package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import flash.text.TextFormat;
   
   public class RoomPlayerItemIip extends BaseTip implements Disposeable, ITip
   {
      
      public static const MAX_HEIGHT:int = 70;
      
      public static const MIN_HEIGHT:int = 22;
       
      
      private var _textFrameArray:Vector.<FilterFrameText>;
      
      private var _contentLabel:TextFormat;
      
      private var _bg:ScaleBitmapImage;
      
      public function RoomPlayerItemIip()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         var _loc1_:FilterFrameText = null;
         var _loc2_:FilterFrameText = null;
         var _loc4_:FilterFrameText = null;
         var _loc5_:FilterFrameText = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTipsBG");
         addChild(this._bg);
         this._textFrameArray = new Vector.<FilterFrameText>();
         _loc1_ = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt");
         _loc1_.visible = false;
         addChild(_loc1_);
         this._textFrameArray.push(_loc1_);
         _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt2");
         _loc2_.visible = false;
         addChild(_loc2_);
         this._textFrameArray.push(_loc2_);
         var _loc3_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt3");
         _loc3_.visible = false;
         addChild(_loc3_);
         this._textFrameArray.push(_loc3_);
         _loc4_ = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt4");
         _loc4_.visible = false;
         addChild(_loc4_);
         this._textFrameArray.push(_loc4_);
         _loc5_ = ComponentFactory.Instance.creatComponentByStylename("ddtroom.roomPlayerItemTips.contentTxt5");
         _loc5_.visible = false;
         addChild(_loc5_);
         this._textFrameArray.push(_loc5_);
         this._contentLabel = ComponentFactory.Instance.model.getSet("ddtroom.roomPlayerItemTips.contentLabelTF");
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         _tipData = param1;
         if(_tipData)
         {
            this.visible = true;
            this.reset();
            this.update();
         }
         else
         {
            this.visible = false;
         }
      }
      
      private function returnFilterFrameText(param1:String) : FilterFrameText
      {
         var _loc4_:FilterFrameText = null;
         var _loc2_:FilterFrameText = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._textFrameArray.length)
         {
            _loc4_ = this._textFrameArray[_loc3_];
            if(_loc4_.text == "" || _loc4_.text == param1)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc3_++;
         }
         return _loc4_;
      }
      
      private function isVisibleFunction() : void
      {
         var _loc2_:FilterFrameText = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._textFrameArray)
         {
            if(_loc2_.text == "")
            {
               _loc2_.visible = false;
            }
            else
            {
               _loc1_++;
               _loc2_.visible = true;
            }
         }
         if(_loc1_ == 0)
         {
            this.visible = false;
         }
      }
      
      private function reset() : void
      {
         var _loc1_:FilterFrameText = null;
         for each(_loc1_ in this._textFrameArray)
         {
            _loc1_.text = "";
         }
      }
      
      private function update() : void
      {
         var _loc1_:PlayerInfo = null;
         var _loc2_:String = null;
         var _loc3_:FilterFrameText = null;
         var _loc4_:String = null;
         var _loc5_:FilterFrameText = null;
         if(_tipData is PlayerInfo)
         {
            _loc1_ = _tipData as PlayerInfo;
            if(_loc1_.ID == _loc1_.ID)
            {
               if(_loc1_.IsMarried)
               {
                  _loc2_ = LanguageMgr.GetTranslation("ddt.room.roomPlayerItemTip.SpouseNameTxt",_loc1_.SpouseName);
                  _loc3_ = this.returnFilterFrameText(_loc2_);
                  if(_loc3_)
                  {
                     _loc3_.text = _loc2_;
                     _loc3_.setTextFormat(this._contentLabel,0,_loc1_.SpouseName.length);
                  }
               }
            }
            else if(_loc1_.IsMarried)
            {
               _loc4_ = LanguageMgr.GetTranslation("ddt.room.roomPlayerItemTip.SpouseNameTxt",_loc1_.SpouseName);
               _loc5_ = this.returnFilterFrameText(_loc4_);
               if(_loc5_)
               {
                  _loc5_.text = _loc4_;
                  _loc5_.setTextFormat(this._contentLabel,0,_loc1_.SpouseName.length);
               }
            }
         }
         this.isVisibleFunction();
         this.updateBgSize();
      }
      
      private function updateBgSize() : void
      {
         this._bg.width = this.getMaxWidth();
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._textFrameArray.length)
         {
            if(this._textFrameArray[_loc2_].visible)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         this._bg.height = _loc1_ * MIN_HEIGHT;
      }
      
      private function getMaxWidth() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._textFrameArray.length)
         {
            if(this._textFrameArray[_loc2_].visible && this._textFrameArray[_loc2_].width > _loc1_)
            {
               _loc1_ = this._textFrameArray[_loc2_].width;
            }
            _loc2_++;
         }
         return _loc1_ + 10;
      }
      
      override public function dispose() : void
      {
         this._textFrameArray = null;
         if(this._contentLabel)
         {
            this._contentLabel = null;
         }
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
