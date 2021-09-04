package SingleDungeon.view
{
   import SingleDungeon.model.MapSceneModel;
   import SingleDungeon.model.MissionType;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class SingleDungeonTip extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _container:Sprite;
      
      private var _descText:FilterFrameText;
      
      private var _lvText:FilterFrameText;
      
      private var _enterCountText:FilterFrameText;
      
      private var _titleText:FilterFrameText;
      
      private var line1:Image;
      
      private var line2:Image;
      
      private var abountTask:FilterFrameText;
      
      private var linePoint:Point;
      
      private var tempArr:Array;
      
      private var _buffInfo:BuffInfo;
      
      public function SingleDungeonTip()
      {
         this.tempArr = new Array();
         super();
      }
      
      override protected function init() : void
      {
         this._container = new Sprite();
         this.linePoint = ComponentFactory.Instance.creatCustomObject("singledungeon.mapTip.LinePoint");
         this._titleText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.mapTip.title");
         this._lvText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.mapTip.level");
         this._enterCountText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.mapTip.enterCount");
         this._enterCountText.text = LanguageMgr.GetTranslation("singleDungeon.bissionView.enterCount",0);
         this._descText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.mapTip.description");
         this._container.addChild(this._titleText);
         this._container.addChild(this._lvText);
         this._container.addChild(this._enterCountText);
         this._container.addChild(this._descText);
         this.line1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this.line1.y = this.linePoint.y;
         this.line1.x = this.linePoint.x;
         this.line1.width = 150;
         this._container.addChild(this.line1);
         this.line2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this.line2.width = 150;
         this.line2.x = this.linePoint.x;
         this.abountTask = ComponentFactory.Instance.creatComponentByStylename("singledungeon.missionTip.description");
         this.abountTask.text = LanguageMgr.GetTranslation("singledungeon.missionTip.abountTask");
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         super.init();
         this.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._container);
         this._container.mouseEnabled = false;
         this._container.mouseChildren = false;
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         var _loc2_:Vector.<QuestInfo> = null;
         if(param1 is MapSceneModel)
         {
            _tipData = param1 as MapSceneModel;
            this._titleText.text = _tipData.Name;
            this._lvText.text = "LV:" + _tipData.MinLevel + "-" + _tipData.MaxLevel;
            if(_tipData.Type == MissionType.ATTACT)
            {
               this._enterCountText.visible = true;
               this._enterCountText.text = LanguageMgr.GetTranslation("singleDungeon.bissionView.enterCount",_tipData.count + this.miningCount());
               this.line1.y = this.linePoint.y;
            }
            else
            {
               this._enterCountText.visible = false;
               this.line1.y = this.linePoint.y - this._enterCountText.height;
            }
            this._descText.y = this.line1.y + 3;
            this._descText.text = _tipData.Description;
            this.line2.y = this._descText.y + this._descText.height + 5;
            _loc2_ = _tipData.questData as Vector.<QuestInfo>;
            this.removeQuestView();
            this.addQuestView(_loc2_);
            this.drawBG();
         }
      }
      
      private function addQuestView(param1:Vector.<QuestInfo>) : void
      {
         var _loc4_:FilterFrameText = null;
         if(param1.length > 0)
         {
            this._container.addChild(this.line2);
            this.abountTask.y = this.line2.y + 8;
            this._container.addChild(this.abountTask);
            this.tempArr.push(this.line2);
            this.tempArr.push(this.abountTask);
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("singledungeon.missionTip.task");
            _loc4_.text = this.analysisType(param1[_loc3_].Type) + " " + param1[_loc3_].Title;
            if(_loc3_ == 0)
            {
               _loc4_.y = this.abountTask.y + 23;
            }
            else
            {
               _loc4_.y = _loc2_[_loc3_ - 1].y + _loc2_[_loc3_ - 1].height + 2;
            }
            this._container.addChild(_loc4_);
            _loc2_.push(_loc4_);
            this.tempArr.push(_loc4_);
            _loc3_++;
         }
      }
      
      private function analysisType(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 0:
               _loc2_ = LanguageMgr.GetTranslation("tank.view.quest.bubble.TankLink");
               break;
            case 1:
               _loc2_ = LanguageMgr.GetTranslation("tank.view.quest.bubble.BranchLine");
               break;
            case 2:
               _loc2_ = LanguageMgr.GetTranslation("tank.view.quest.bubble.Daily");
               break;
            case 3:
               _loc2_ = LanguageMgr.GetTranslation("tank.view.quest.bubble.Act");
               break;
            case 4:
               _loc2_ = LanguageMgr.GetTranslation("tank.view.quest.bubble.VIP");
         }
         return _loc2_;
      }
      
      private function removeQuestView() : void
      {
         while(this.tempArr.length > 0)
         {
            this._container.removeChild(this.tempArr.pop());
         }
      }
      
      private function drawBG() : void
      {
         this._bg.width = this._container.width + 20;
         this._bg.height = this._container.height + 20;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      private function miningCount() : int
      {
         if(!PlayerManager.Instance.Self.consortionStatus)
         {
            return 0;
         }
         if(_tipData.Type == MissionType.ATTACT)
         {
            this._buffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.ADD_SIRIKE_COPY_COUNT];
         }
         if(this._buffInfo == null)
         {
            return 0;
         }
         return this._buffInfo.ValidCount;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this.line1);
         this.line1 = null;
         ObjectUtils.disposeObject(this.line2);
         this.line2 = null;
         ObjectUtils.disposeObject(this._descText);
         this._descText = null;
         ObjectUtils.disposeObject(this._titleText);
         this._titleText = null;
         ObjectUtils.disposeObject(this._lvText);
         this._lvText = null;
         ObjectUtils.disposeObject(this.abountTask);
         this.abountTask = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this.removeQuestView();
         while(this._container && this._container.numChildren > 0)
         {
            this._container.removeChildAt(0);
         }
         ObjectUtils.disposeObject(this._container);
         this._container = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
