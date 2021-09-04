package room.view.smallMapInfoPanel
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.FilterFrameTextWithTips;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class MissionRoomSmallMapInfoPanel extends BaseSmallMapInfoPanel
   {
       
      
      protected var _diffTitle:FilterFrameText;
      
      protected var _diff:FilterFrameText;
      
      protected var _levelRangeTitle:FilterFrameText;
      
      protected var _levelRange:FilterFrameText;
      
      protected var _needEnergyTitle:FilterFrameTextWithTips;
      
      protected var _needEnergy:FilterFrameText;
      
      protected var _titleLoader:DisplayLoader;
      
      protected var _titleIconContainer:Sprite;
      
      protected var _roomInfoBg:Bitmap;
      
      protected var _MapBg:Bitmap;
      
      public function MissionRoomSmallMapInfoPanel()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this._MapBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.mapBtnAsset");
         addChild(this._MapBg);
         super.initView();
         this._titleIconContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.challenge.chooseMap.titleSprite");
         this._titleIconContainer.visible = false;
         PositionUtils.setPos(this._titleIconContainer,"asset.ddtroom.dungeonSmallMap.titleIconPos");
         this._roomInfoBg = ComponentFactory.Instance.creatBitmap("asser.ddtroom.dungeonSmallMapOverbg");
         this._roomInfoBg.visible = false;
         addChild(this._roomInfoBg);
         this._needEnergyTitle = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.needEnergyTitle");
         this._needEnergyTitle.tipGapH = 0;
         this._needEnergyTitle.tipGapV = -30;
         this._needEnergyTitle.tipStyle = "ddt.view.tips.OneLineTip";
         this._needEnergyTitle.tipData = LanguageMgr.GetTranslation("tank.multiDungeon.needEnergyDesc");
         this._needEnergyTitle.text = LanguageMgr.GetTranslation("tank.multiDungeon.needEnergy");
         addChild(this._needEnergyTitle);
         this._needEnergy = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.needEnergyTxt");
         addChild(this._needEnergy);
         this._diffTitle = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.diffTitle");
         addChild(this._diffTitle);
         this._levelRangeTitle = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.levelRangeTitle");
         addChild(this._levelRangeTitle);
         this._diff = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.diff");
         addChild(this._diff);
         this._levelRange = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.smallMap.levelRange");
         addChild(this._levelRange);
         this._diffTitle.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.diffTitle");
         this._levelRangeTitle.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.levelRange");
         addChild(this._titleIconContainer);
      }
      
      override protected function updateView() : void
      {
         super.updateView();
         this._roomInfoBg.visible = this._titleIconContainer.visible = this._levelRangeTitle.visible = this._diffTitle.visible = this._levelRange.visible = this._diff.visible = this._needEnergyTitle.visible = this._needEnergy.visible = _info && _info.mapId != 0 && _info.mapId != 10000;
         this.solveLeveRange();
         this._diff.text = LanguageMgr.GetTranslation("ddt.dungeonRoom.level" + _info.hardLevel);
         if(_info && _info.mapId != 0 && _info.mapId != 10000)
         {
            this._needEnergy.text = MapManager.getDungeonInfo(_info.mapId).Energy[_info.hardLevel].toString();
            if(_info.mapId == 17)
            {
               this._needEnergy.visible = false;
               this._needEnergyTitle.visible = false;
            }
         }
         if(this._titleLoader)
         {
            this._titleLoader = null;
         }
         this._titleLoader = LoadResourceManager.instance.createLoader(PathManager.solveMapIconPath(_info.mapId,0),BaseLoader.BITMAP_LOADER);
         this._titleLoader.addEventListener(LoaderEvent.COMPLETE,this.__titleCompleteHandler);
         LoadResourceManager.instance.startLoad(this._titleLoader);
      }
      
      private function __titleCompleteHandler(param1:LoaderEvent) : void
      {
         ObjectUtils.disposeAllChildren(this._titleIconContainer);
         if(param1.loader.isSuccess)
         {
            param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__titleCompleteHandler);
            this._titleIconContainer.addChild(param1.loader.content as Bitmap);
         }
      }
      
      private function solveLeveRange() : void
      {
         var _loc2_:Array = null;
         if(_info == null || _info.mapId == 0 || _info.mapId == 10000)
         {
            return;
         }
         var _loc1_:String = MapManager.getDungeonInfo(_info.mapId).AdviceTips;
         if(_loc1_)
         {
            _loc2_ = _loc1_.split("|");
            this._levelRange.text = "";
            if(_info.hardLevel >= _loc2_.length)
            {
               return;
            }
            this._levelRange.text = _loc2_[_info.hardLevel] + LanguageMgr.GetTranslation("grade");
         }
      }
      
      override public function dispose() : void
      {
         if(this._diffTitle)
         {
            ObjectUtils.disposeObject(this._diffTitle);
            this._diffTitle = null;
         }
         if(this._diff)
         {
            ObjectUtils.disposeObject(this._diff);
            this._diff = null;
         }
         if(this._levelRangeTitle)
         {
            ObjectUtils.disposeObject(this._levelRangeTitle);
            this._levelRangeTitle = null;
         }
         if(this._levelRange)
         {
            ObjectUtils.disposeObject(this._levelRange);
            this._levelRange = null;
         }
         super.dispose();
      }
   }
}
