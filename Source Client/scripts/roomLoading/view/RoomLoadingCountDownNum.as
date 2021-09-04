package roomLoading.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class RoomLoadingCountDownNum extends Sprite implements Disposeable
   {
       
      
      private var _numTxt:FilterFrameText;
      
      private var _num:int;
      
      private var _countDownBg:Bitmap;
      
      private var _bitmapDatas:Vector.<BitmapData>;
      
      private var _tenDigit:Bitmap;
      
      private var _digit:Bitmap;
      
      public function RoomLoadingCountDownNum()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._num = RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM ? int(90) : int(60);
         this._countDownBg = ComponentFactory.Instance.creatBitmap("asset.roomloading.countDownBg");
         this._tenDigit = new Bitmap();
         this._digit = new Bitmap();
         TweenMax.fromTo(this._tenDigit,0.5,{
            "scaleX":0.5,
            "scaleY":0.5,
            "ease":Quint.easeIn,
            "alpha":0
         },{
            "scaleX":1,
            "scaleY":1,
            "alpha":1
         });
         TweenMax.fromTo(this._digit,0.5,{
            "scaleX":0.5,
            "scaleY":0.5,
            "ease":Quint.easeIn,
            "alpha":0
         },{
            "scaleX":1,
            "scaleY":1,
            "alpha":1
         });
         this._bitmapDatas = new Vector.<BitmapData>();
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData("asset.roomloading.countDownNum_" + _loc1_));
            _loc1_++;
         }
         this.updateNumView();
      }
      
      public function updateNum() : void
      {
         --this._num;
         if(this._num < 0)
         {
            this._num = 0;
         }
         this.updateNumView();
      }
      
      private function updateNumView() : void
      {
         this._tenDigit.bitmapData = this._bitmapDatas[int(this._num / 10)];
         this._digit.bitmapData = this._bitmapDatas[this._num % 10];
         PositionUtils.setPos(this._tenDigit,"asset.roomloading.tenDigitPos");
         PositionUtils.setPos(this._digit,"asset.roomloading.digitPos");
         addChild(this._tenDigit);
         addChild(this._digit);
      }
      
      public function dispose() : void
      {
         var _loc1_:BitmapData = null;
         ObjectUtils.disposeObject(this._countDownBg);
         this._countDownBg = null;
         for each(_loc1_ in this._bitmapDatas)
         {
            _loc1_.dispose();
         }
         TweenMax.killTweensOf(this._tenDigit);
         ObjectUtils.disposeObject(this._tenDigit);
         this._tenDigit = null;
         TweenMax.killTweensOf(this._digit);
         ObjectUtils.disposeObject(this._digit);
         this._digit = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
