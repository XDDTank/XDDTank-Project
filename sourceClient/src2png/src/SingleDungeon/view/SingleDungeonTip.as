// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.view.SingleDungeonTip

package SingleDungeon.view
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.Sprite;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Image;
    import flash.geom.Point;
    import ddt.data.BuffInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import __AS3__.vec.Vector;
    import ddt.data.quest.QuestInfo;
    import SingleDungeon.model.MapSceneModel;
    import SingleDungeon.model.MissionType;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

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
        private var tempArr:Array = new Array();
        private var _buffInfo:BuffInfo;


        override protected function init():void
        {
            this._container = new Sprite();
            this.linePoint = ComponentFactory.Instance.creatCustomObject("singledungeon.mapTip.LinePoint");
            this._titleText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.mapTip.title");
            this._lvText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.mapTip.level");
            this._enterCountText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.mapTip.enterCount");
            this._enterCountText.text = LanguageMgr.GetTranslation("singleDungeon.bissionView.enterCount", 0);
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

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._container);
            this._container.mouseEnabled = false;
            this._container.mouseChildren = false;
            mouseChildren = false;
            mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            var _local_2:Vector.<QuestInfo>;
            if ((_arg_1 is MapSceneModel))
            {
                _tipData = (_arg_1 as MapSceneModel);
                this._titleText.text = _tipData.Name;
                this._lvText.text = ((("LV:" + _tipData.MinLevel) + "-") + _tipData.MaxLevel);
                if (_tipData.Type == MissionType.ATTACT)
                {
                    this._enterCountText.visible = true;
                    this._enterCountText.text = LanguageMgr.GetTranslation("singleDungeon.bissionView.enterCount", (_tipData.count + this.miningCount()));
                    this.line1.y = this.linePoint.y;
                }
                else
                {
                    this._enterCountText.visible = false;
                    this.line1.y = (this.linePoint.y - this._enterCountText.height);
                };
                this._descText.y = (this.line1.y + 3);
                this._descText.text = _tipData.Description;
                this.line2.y = ((this._descText.y + this._descText.height) + 5);
                _local_2 = (_tipData.questData as Vector.<QuestInfo>);
                this.removeQuestView();
                this.addQuestView(_local_2);
                this.drawBG();
            };
        }

        private function addQuestView(_arg_1:Vector.<QuestInfo>):void
        {
            var _local_4:FilterFrameText;
            if (_arg_1.length > 0)
            {
                this._container.addChild(this.line2);
                this.abountTask.y = (this.line2.y + 8);
                this._container.addChild(this.abountTask);
                this.tempArr.push(this.line2);
                this.tempArr.push(this.abountTask);
            };
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_4 = ComponentFactory.Instance.creatComponentByStylename("singledungeon.missionTip.task");
                _local_4.text = ((this.analysisType(_arg_1[_local_3].Type) + " ") + _arg_1[_local_3].Title);
                if (_local_3 == 0)
                {
                    _local_4.y = (this.abountTask.y + 23);
                }
                else
                {
                    _local_4.y = ((_local_2[(_local_3 - 1)].y + _local_2[(_local_3 - 1)].height) + 2);
                };
                this._container.addChild(_local_4);
                _local_2.push(_local_4);
                this.tempArr.push(_local_4);
                _local_3++;
            };
        }

        private function analysisType(_arg_1:int):String
        {
            var _local_2:String;
            switch (_arg_1)
            {
                case 0:
                    _local_2 = LanguageMgr.GetTranslation("tank.view.quest.bubble.TankLink");
                    break;
                case 1:
                    _local_2 = LanguageMgr.GetTranslation("tank.view.quest.bubble.BranchLine");
                    break;
                case 2:
                    _local_2 = LanguageMgr.GetTranslation("tank.view.quest.bubble.Daily");
                    break;
                case 3:
                    _local_2 = LanguageMgr.GetTranslation("tank.view.quest.bubble.Act");
                    break;
                case 4:
                    _local_2 = LanguageMgr.GetTranslation("tank.view.quest.bubble.VIP");
                    break;
            };
            return (_local_2);
        }

        private function removeQuestView():void
        {
            while (this.tempArr.length > 0)
            {
                this._container.removeChild(this.tempArr.pop());
            };
        }

        private function drawBG():void
        {
            this._bg.width = (this._container.width + 20);
            this._bg.height = (this._container.height + 20);
            _width = this._bg.width;
            _height = this._bg.height;
        }

        private function miningCount():int
        {
            if ((!(PlayerManager.Instance.Self.consortionStatus)))
            {
                return (0);
            };
            if (_tipData.Type == MissionType.ATTACT)
            {
                this._buffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.ADD_SIRIKE_COPY_COUNT];
            };
            if (this._buffInfo == null)
            {
                return (0);
            };
            return (this._buffInfo.ValidCount);
        }

        override public function dispose():void
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
            while (((this._container) && (this._container.numChildren > 0)))
            {
                this._container.removeChildAt(0);
            };
            ObjectUtils.disposeObject(this._container);
            this._container = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package SingleDungeon.view

