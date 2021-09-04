package game.view.tool
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameManager;
   import game.objects.DamageObject;
   
   public class DamageStrip extends Sprite implements Disposeable
   {
      
      public static const HEIGHT:int = 42;
       
      
      private var _damageText:FilterFrameText;
      
      private var _damageText2:FilterFrameText;
      
      private var _reduceMC:MovieClip;
      
      private var _damageBg:MovieClip;
      
      private var _picBmp:Bitmap;
      
      private var _picPos:Point;
      
      private var _width:Number = 0;
      
      private var _info:DamageObject;
      
      public function DamageStrip()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._damageText = UICreatShortcut.creatAndAdd("ddt.multiShoot.damageText",this);
         this._damageText2 = UICreatShortcut.creatAndAdd("ddt.multiShoot.damageText2",this);
         this._damageText2.text = LanguageMgr.GetTranslation("ddt.game.view.damageStasticText3");
         this._reduceMC = UICreatShortcut.creatAndAdd("ddt.game.view.damageStrip.reduceMC",this);
         this._picPos = ComponentFactory.Instance.creat("ddt.game.view.damageStrip.numPos");
      }
      
      override public function get height() : Number
      {
         return HEIGHT;
      }
      
      public function get info() : DamageObject
      {
         return this._info;
      }
      
      public function set info(param1:DamageObject) : void
      {
         var _loc2_:int = 0;
         this._info = param1;
         if(this._info)
         {
            _loc2_ = String(this._info.damage).length;
            if(_loc2_ > 5)
            {
               _loc2_ = 5;
            }
            this._damageBg = ComponentFactory.Instance.creat("asset.game.damageBgAsset" + _loc2_);
            addChildAt(this._damageBg,0);
            this._damageBg.stop();
            this._damageText.htmlText = LanguageMgr.GetTranslation("ddt.game.view.damageStasticText" + (!!this._info.isSelf ? 1 : 2),this._info.playerName);
            this._damageText.alpha = 0.2;
            this._damageText.y = 23;
            ObjectUtils.disposeObject(this._picBmp);
            this._picBmp = this.getPercent(this._info.damage);
            this._picBmp.y = this._picPos.y + 23;
            addChild(this._picBmp);
            this._picBmp.alpha = 0.2;
            if(this._info.reducePercent > 0)
            {
               this._reduceMC.setPercent(this._info.reducePercent);
               this._reduceMC.visible = true;
            }
            else
            {
               this._reduceMC.visible = false;
            }
            this.width = this._damageText.width + this._picBmp.width + this._damageText2.width + (!!this._reduceMC.visible ? 150 : 0);
         }
      }
      
      public function show() : void
      {
         TweenLite.to(this._damageText,0.2,{
            "alpha":1,
            "y":0
         });
         TweenLite.to(this._picBmp,0.2,{
            "alpha":1,
            "y":this._picPos.y
         });
         this._reduceMC.gotoAndPlay(1);
         this._damageBg.gotoAndPlay(1);
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc2_:int = 0;
         this._width = param1;
         if(this._reduceMC.visible)
         {
            this._damageText.x = -param1;
            this._picBmp.x = this._damageText.x + this._damageText.width - 1;
            this._damageText2.x = this._damageText.x + this._damageText.width + this._picBmp.width;
            this._damageBg.x = this._picBmp.x + this._picBmp.width / 2;
            this._damageBg.y = this._picPos.y + this._picBmp.height / 2 - 2;
         }
         else
         {
            _loc2_ = 0;
            _loc2_ = this._damageText2.x = _loc2_ - this._damageText2.width;
            _loc2_ = this._picBmp.x = _loc2_ - this._picBmp.width - 1;
            this._damageBg.x = this._picBmp.x + this._picBmp.width / 2;
            this._damageBg.y = this._picPos.y + this._picBmp.height / 2 - 2;
            this._damageText.x = _loc2_ - this._damageText.width;
         }
         this._width = param1;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      public function updateUI() : void
      {
      }
      
      public function getTextWidth() : Number
      {
         return this._damageText.textWidth;
      }
      
      public function getPercent(param1:int) : Bitmap
      {
         var _loc8_:Bitmap = null;
         var _loc9_:BitmapData = null;
         if(param1 > 99999999)
         {
            return null;
         }
         var _loc2_:Array = new Array();
         _loc2_ = [0,0,0,0];
         var _loc3_:Array = new Array();
         var _loc4_:String = String(param1);
         var _loc5_:int = _loc4_.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc9_ = GameManager.Instance.numCreater.damageData[int(_loc4_.charAt(_loc6_))];
            _loc3_.push(_loc6_ * _loc9_.width - 1);
            _loc2_.push(_loc9_);
            _loc6_++;
         }
         _loc2_ = this.returnNum(_loc2_,_loc3_);
         var _loc7_:BitmapData = new BitmapData(_loc2_[2],_loc2_[3],true,0);
         _loc8_ = new Bitmap(_loc7_,"auto",true);
         _loc6_ = 4;
         while(_loc6_ < _loc2_.length)
         {
            _loc7_.copyPixels(_loc2_[_loc6_],new Rectangle(0,0,_loc2_[_loc6_].width,_loc2_[_loc6_].height),new Point(_loc3_[_loc6_ - 4] - _loc2_[0],_loc2_[_loc6_].rect.y - _loc2_[1]),null,null,true);
            _loc6_++;
         }
         _loc8_.x = _loc2_[0];
         _loc8_.y = _loc2_[1];
         _loc2_ = null;
         _loc8_.smoothing = true;
         return _loc8_;
      }
      
      private function returnNum(param1:Array, param2:Array) : Array
      {
         var _loc3_:int = 4;
         while(_loc3_ < param1.length)
         {
            param1[0] = param1[0] > param2[_loc3_ - 4] ? param2[_loc3_ - 4] : param1[0];
            param1[1] = param1[1] > param1[_loc3_].rect.y ? param1[_loc3_].rect.y : param1[1];
            param1[2] = param1[2] > param1[_loc3_].width + param2[_loc3_ - 4] ? param1[2] : param1[_loc3_].width + param2[_loc3_ - 4];
            param1[3] = param1[3] > param1[_loc3_].height + param1[_loc3_].rect.y ? param1[3] : param1[_loc3_].height + param1[_loc3_].rect.y;
            _loc3_++;
         }
         param1[2] -= param1[0];
         param1[3] -= param1[1];
         return param1;
      }
      
      public function dispose() : void
      {
         TweenLite.killTweensOf(this._damageText);
         ObjectUtils.disposeObject(this._damageText);
         this._damageText = null;
         ObjectUtils.disposeObject(this._damageText2);
         this._damageText2 = null;
         ObjectUtils.disposeObject(this._reduceMC);
         this._reduceMC = null;
         ObjectUtils.disposeObject(this._picBmp);
         this._picBmp = null;
         ObjectUtils.disposeObject(this._damageBg);
         this._damageBg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
