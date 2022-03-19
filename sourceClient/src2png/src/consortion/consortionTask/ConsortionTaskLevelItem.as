// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.consortionTask.ConsortionTaskLevelItem

package consortion.consortionTask
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ShowTipManager;
    import consortion.ConsortionModel;
    import consortion.ConsortionModelControl;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import consortion.event.ConsortionEvent;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class ConsortionTaskLevelItem extends Sprite implements Disposeable, ITipedDisplay 
    {

        private var _type:uint = 0;
        private var _tipData:Object;
        private var _bg:MutipleImage;
        private var _iconShine:Scale9CornerImage;
        private var _icon:MutipleImage;
        private var _taskName:FilterFrameText;
        private var _taskCost1:FilterFrameText;
        private var _taskCost2:FilterFrameText;
        private var _selected:Boolean;
        private var _enable:Boolean;

        public function ConsortionTaskLevelItem(_arg_1:uint)
        {
            this.init();
            this._type = _arg_1;
            this.initView();
        }

        private function init():void
        {
            this._taskName = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.taskName.text");
            this._taskCost1 = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.cost1.text");
            this._taskCost2 = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.cost2.text");
            this._taskCost1.text = LanguageMgr.GetTranslation("ddt.pets.skillTipLost");
        }

        private function initView():void
        {
            this._enable = true;
            this.buttonMode = true;
            this.useHandCursor = true;
            ShowTipManager.Instance.addTip(this);
            this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.onsortionTaskLevelItemBg");
            addChild(this._bg);
            this._iconShine = ComponentFactory.Instance.creatComponentByStylename("consortion.onsortionTaskLevelIconShine");
            switch (this._type)
            {
                case ConsortionModel.TASKLEVELI:
                    this._taskName.text = (LanguageMgr.GetTranslation("consortion.ConsortionTask.level1") + LanguageMgr.GetTranslation("consortion.ConsortionCampaign.taskTitle.text"));
                    this._icon = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.levelIcon1");
                    break;
                case ConsortionModel.TASKLEVELII:
                    this._taskName.text = (LanguageMgr.GetTranslation("consortion.ConsortionTask.level2") + LanguageMgr.GetTranslation("consortion.ConsortionCampaign.taskTitle.text"));
                    this._icon = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.levelIcon2");
                    break;
                case ConsortionModel.TASKLEVELIII:
                    this._taskName.text = (LanguageMgr.GetTranslation("consortion.ConsortionTask.level3") + LanguageMgr.GetTranslation("consortion.ConsortionCampaign.taskTitle.text"));
                    this._icon = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.levelIcon3");
                    break;
                case ConsortionModel.TASKLEVELIV:
                    this._taskName.text = (LanguageMgr.GetTranslation("consortion.ConsortionTask.level4") + LanguageMgr.GetTranslation("consortion.ConsortionCampaign.taskTitle.text"));
                    this._icon = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionTask.levelIcon4");
                    break;
            };
            this._bg.addChild(this._icon);
            this._bg.addChild(this._taskName);
            this._bg.addChild(this._taskCost1);
            this._bg.addChild(this._taskCost2);
            this._iconShine.visible = false;
            addChild(this._iconShine);
            this._taskCost2.text = (ConsortionModelControl.Instance.model.getTaskCost(this._type) + LanguageMgr.GetTranslation("consortia.Money"));
            this._tipData = ConsortionModelControl.Instance.model.getTaskLevelString(this._type);
            this.addEventListener(MouseEvent.CLICK, this.__changeTaskLevel);
        }

        private function __changeTaskLevel(_arg_1:MouseEvent):void
        {
            if ((!(this._enable)))
            {
                return;
            };
            SoundManager.instance.play("008");
            dispatchEvent(new ConsortionEvent(ConsortionEvent.CONSORTION_TASK_LEVEL_CHANGE, this._type));
        }

        public function get type():uint
        {
            return (this._type);
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
        }

        public function get tipDirctions():String
        {
            return ("3");
        }

        public function set tipDirctions(_arg_1:String):void
        {
        }

        public function get tipGapH():int
        {
            return (0);
        }

        public function set tipGapH(_arg_1:int):void
        {
        }

        public function get tipGapV():int
        {
            return (0);
        }

        public function set tipGapV(_arg_1:int):void
        {
        }

        public function get tipStyle():String
        {
            return ("consortion.ConsortiaTaskLevelTip");
        }

        public function set tipStyle(_arg_1:String):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            ObjectUtils.disposeAllChildren(this);
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._iconShine);
            this._iconShine = null;
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
            ObjectUtils.disposeObject(this._taskCost1);
            this._taskCost1 = null;
            ObjectUtils.disposeObject(this._taskCost2);
            this._taskCost2 = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            this._selected = _arg_1;
            if (this._selected)
            {
                this._iconShine.visible = true;
            }
            else
            {
                this._iconShine.visible = false;
            };
        }

        public function get enable():Boolean
        {
            return (this._enable);
        }

        public function set enable(_arg_1:Boolean):void
        {
            var _local_2:Array;
            if (this._enable == _arg_1)
            {
                return;
            };
            this._enable = _arg_1;
            this.mouseEnabled = _arg_1;
            this.buttonMode = _arg_1;
            this.useHandCursor = _arg_1;
            if ((!(this._enable)))
            {
                _local_2 = ComponentFactory.Instance.creatFilters("grayFilter");
                this.filters = _local_2;
            };
        }


    }
}//package consortion.consortionTask

