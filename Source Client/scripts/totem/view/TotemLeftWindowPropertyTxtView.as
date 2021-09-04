package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemLeftWindowPropertyTxtView extends Sprite implements Disposeable
   {
       
      
      private var _levelTxtList:Vector.<FilterFrameText>;
      
      private var _txtArray:Array;
      
      private var _totemInfo:TotemDataVo;
      
      public function TotemLeftWindowPropertyTxtView()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this._levelTxtList = new Vector.<FilterFrameText>();
         var _loc1_:int = 1;
         while(_loc1_ <= 7)
         {
            this._levelTxtList.push(ComponentFactory.Instance.creatComponentByStylename("totem.totemWindow.propertyName" + _loc1_));
            _loc1_++;
         }
         var _loc2_:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
         this._txtArray = _loc2_.split(",");
      }
      
      public function show(param1:Array, param2:TotemDataVo = null, param3:int = 0) : void
      {
         this._totemInfo = param2;
         var _loc4_:int = 0;
         while(_loc4_ < 7)
         {
            this._levelTxtList[_loc4_].x = param1[_loc4_].x + 18;
            this._levelTxtList[_loc4_].y = param1[_loc4_].y + 81;
            this._levelTxtList[_loc4_].text += "+" + TotemManager.instance.getAddValue(_loc4_ + 1,TotemManager.instance.getAddInfo(this.getStopLv(this._totemInfo,param3)));
            addChild(this._levelTxtList[_loc4_]);
            _loc4_++;
         }
      }
      
      private function getStopLv(param1:TotemDataVo, param2:int) : int
      {
         var _loc3_:int = 0;
         if(param1 && param1.Page == param2)
         {
            _loc3_ = TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId);
         }
         else
         {
            _loc3_ = param2 * 70;
         }
         return _loc3_;
      }
      
      public function refreshLayer(param1:int, param2:TotemDataVo = null, param3:int = 0) : void
      {
         this._totemInfo = param2;
         var _loc4_:Array = TotemManager.instance.getCurrentLvList(TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId),param3,this._totemInfo);
         var _loc5_:int = 0;
         while(_loc5_ < 7)
         {
            this._levelTxtList[_loc5_].text = LanguageMgr.GetTranslation("ddt.totem.totemWindow.propertyLvTxt",_loc4_[_loc5_],this._txtArray[_loc5_] + "+" + TotemManager.instance.getAddValue(_loc5_ + 1,TotemManager.instance.getAddInfo(this.getStopLv(this._totemInfo,param3))));
            _loc5_++;
         }
      }
      
      public function scaleTxt(param1:Number) : void
      {
         if(!this._levelTxtList)
         {
            return;
         }
         var _loc2_:int = this._levelTxtList.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._levelTxtList[_loc3_].scaleX = param1;
            this._levelTxtList[_loc3_].scaleY = param1;
            this._levelTxtList[_loc3_].x -= 5;
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._levelTxtList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
