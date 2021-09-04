package game.view.buff
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortionNewSkillInfo;
   import ddt.data.BuffType;
   import ddt.data.FightBuffInfo;
   import ddt.data.FightConsotionBuff;
   import ddt.display.BitmapLoaderProxy;
   import ddt.display.BitmapObject;
   import ddt.display.BitmapSprite;
   import ddt.manager.BitmapManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.view.tips.BuffTipInfo;
   import ddt.view.tips.PropTxtTipInfo;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class BuffCell extends BitmapSprite implements ITipedDisplay
   {
       
      
      private var _info:FightBuffInfo;
      
      private var _bitmapMgr:BitmapManager;
      
      private var _tipData:PropTxtTipInfo;
      
      private var _txt:FilterFrameText;
      
      private var _loaderProxy:BitmapLoaderProxy;
      
      public function BuffCell(param1:BitmapObject = null, param2:Matrix = null, param3:Boolean = true, param4:Boolean = false)
      {
         this._tipData = new PropTxtTipInfo();
         super(param1,param2,false,true);
         this._bitmapMgr = BitmapManager.getBitmapMgr("GameView");
         this._tipData = new PropTxtTipInfo();
         this._tipData.color = 15790320;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("game.petskillBuff.numTxt");
         addChild(this._txt);
      }
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         if(this._loaderProxy)
         {
            this._loaderProxy.dispose();
         }
         this._loaderProxy = null;
         this._info = null;
         this._tipData = null;
         this._bitmapMgr.dispose();
         this._bitmapMgr = null;
         this._info = null;
         super.dispose();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function clearSelf() : void
      {
         ShowTipManager.Instance.removeTip(this);
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._loaderProxy)
         {
            this._loaderProxy.dispose();
         }
         this._loaderProxy = null;
         clearBitmap();
         ObjectUtils.disposeObject(bitmapObject);
         bitmapObject = null;
         this._info = null;
      }
      
      public function setInfo(param1:FightBuffInfo) : void
      {
         var _loc2_:ConsortionNewSkillInfo = null;
         if(this._loaderProxy)
         {
            this._loaderProxy.dispose();
         }
         this._loaderProxy = null;
         clearBitmap();
         ObjectUtils.disposeObject(bitmapObject);
         bitmapObject = null;
         this._info = param1;
         this._tipData.property = this._info.buffName;
         this._tipData.detail = this._info.description;
         if(param1.type == BuffType.PET_BUFF)
         {
            this._loaderProxy = new BitmapLoaderProxy(PathManager.solvePetBuff(param1.buffPic),new Rectangle(0,0,32,32));
            addChild(this._loaderProxy);
            ShowTipManager.Instance.addTip(this);
         }
         else if(param1.type == BuffType.CONSORTIA && (PlayerManager.Instance.Self.consortionStatus || !param1.isSelf))
         {
            _loc2_ = ConsortionModelControl.Instance.model.getInfoByType(param1.id);
            if(_loc2_)
            {
               this._loaderProxy = new BitmapLoaderProxy(PathManager.solveConsortionBuff(_loc2_.Pic),new Rectangle(0,0,32,32));
               addChild(this._loaderProxy);
               ShowTipManager.Instance.addTip(this);
            }
         }
         else if(param1.type == BuffType.MILITARY_BUFF)
         {
            bitmapObject = this._bitmapMgr.getBitmap("asset.game.buff14");
         }
         else if(param1.displayid != 101)
         {
            bitmapObject = this._bitmapMgr.getBitmap("asset.game.buff" + this._info.displayid);
         }
         if(param1.displayid == BuffType.ARENA_MARS)
         {
            ShowTipManager.Instance.addTip(this);
         }
         if(this._info.Count > 1)
         {
            addChild(this._txt);
            this._txt.text = this._info.Count.toString();
         }
         else if(contains(this._txt))
         {
            removeChild(this._txt);
         }
         if(BuffType.isLocalBuffByID(this._info.id) || BuffType.isContainerBuff(this._info))
         {
            ShowTipManager.Instance.addTip(this);
         }
      }
      
      public function get tipData() : Object
      {
         var _loc2_:BuffTipInfo = null;
         var _loc1_:FightConsotionBuff = new FightConsotionBuff(this._info);
         if(BuffType.isContainerBuff(this._info))
         {
            return _loc1_.tipData;
         }
         if(BuffType.isMilitaryBuff(this._info.id) || BuffType.isArenaBufferByID(this._info.id))
         {
            _loc2_ = new BuffTipInfo();
            _loc2_.name = this._info.buffName;
            _loc2_.describe = this._info.description;
            return _loc2_;
         }
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return "7,6,5,1,6,4";
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 6;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 6;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         if(BuffType.isContainerBuff(this._info) || BuffType.isMilitaryBuff(this._info.id) || BuffType.isArenaBufferByID(this._info.id))
         {
            return "core.PayBuffTip";
         }
         return "core.FightBuffTip";
      }
      
      public function set tipStyle(param1:String) : void
      {
      }
   }
}
