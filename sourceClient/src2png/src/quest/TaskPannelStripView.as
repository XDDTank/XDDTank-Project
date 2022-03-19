﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.TaskPannelStripView

package quest
{
    import flash.display.Sprite;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import ddt.data.quest.QuestInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.TaskManager;
    import ddt.events.TaskEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class TaskPannelStripView extends Sprite 
    {

        private static const THIS_HEIGHT:int = 37;
        private static const THIS_WIDTH:int = 214;

        private var _bg:ScaleFrameImage;
        private var _info:QuestInfo;
        private var _status:String;
        private var titleField:FilterFrameText;
        private var bmpNEW:MovieClip;
        private var bmpOK:Bitmap;
        private var bmpRecommond:Bitmap;
        private var _style:int = 1;

        public function TaskPannelStripView(_arg_1:QuestInfo)
        {
            this._info = _arg_1;
            this.initView();
            this.addEvent();
        }

        public function set status(_arg_1:String):void
        {
            if (_arg_1 == this._status)
            {
                return;
            };
            this._status = _arg_1;
            this.update();
        }

        private function get isHovered():Boolean
        {
            return (this._status == "hover");
        }

        private function get isSelected():Boolean
        {
            return (this._status == "active");
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creat("core.quest.MCQuestItemBG");
            this._bg.setFrame(1);
            addChild(this._bg);
            this.titleField = ComponentFactory.Instance.creat("core.quest.QuestItemTitleNormal");
            addChild(this.titleField);
            mouseChildren = false;
            buttonMode = true;
            this.bmpNEW = (ClassUtils.CreatInstance("asset.quest.newMovie") as MovieClip);
            this.bmpNEW.visible = false;
            addChild(this.bmpNEW);
            PositionUtils.setPos(this.bmpNEW, "quest.bmpNEWPosForStrip");
            this.bmpOK = ComponentFactory.Instance.creat("asset.core.quest.textImg.OK");
            this.bmpOK.visible = false;
            addChild(this.bmpOK);
            this.bmpRecommond = ComponentFactory.Instance.creatBitmap("asset.core.quest.recommend");
            this.bmpRecommond.rotation = 15;
            this.bmpRecommond.smoothing = true;
            this.bmpRecommond.visible = false;
            addChild(this.bmpRecommond);
            this.titleField.text = this._info.Title;
            this.status = "normal";
            this.update();
        }

        public function set taskStyle(_arg_1:int):void
        {
            this._style = _arg_1;
        }

        public function get info():QuestInfo
        {
            return (this._info);
        }

        protected function addEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__onRollOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__onRollOut);
            addEventListener(MouseEvent.CLICK, this.__onClick);
        }

        protected function removeEvent():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__onRollOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__onRollOut);
            removeEventListener(MouseEvent.CLICK, this.__onClick);
        }

        public function update():void
        {
            if (((this._info.isCompleted) || ((this._info.data) && (this._info.data.isCompleted))))
            {
                this.bmpOK.visible = true;
            }
            else
            {
                this.bmpOK.visible = false;
                if (this._info.StarLev == 1)
                {
                    this.bmpRecommond.visible = true;
                }
                else
                {
                    this.bmpRecommond.visible = false;
                    if (((this._info.data) && (this._info.data.isNew)))
                    {
                        if (this.bmpNEW.visible == false)
                        {
                            this.bmpNEW.visible = true;
                            this.bmpNEW.gotoAndPlay(1);
                        };
                    }
                    else
                    {
                        this.bmpNEW.visible = false;
                    };
                };
            };
            if (((this._info.data) && (this._info.data.quality > 1)))
            {
                this.titleField.setFrame(2);
            }
            else
            {
                this.titleField.setFrame(1);
            };
            if (this.isSelected)
            {
                this._bg.setFrame(2);
                if (((this._info.data) && (this._info.data.quality > 1)))
                {
                    this.titleField.setFrame(1);
                }
                else
                {
                    this.titleField.setFrame(2);
                };
            }
            else
            {
                this._bg.setFrame(1);
            };
        }

        private function __onRollOver(_arg_1:MouseEvent):void
        {
            if (this.isSelected)
            {
                return;
            };
            this.status = "hover";
        }

        private function __onRollOut(_arg_1:MouseEvent):void
        {
            if (this.isSelected)
            {
                return;
            };
            this.status = "normal";
        }

        private function __onClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            TaskManager.instance.MainFrame.currentNewCateView = null;
            this._info.data.isNew = false;
            this._active();
        }

        protected function _active():void
        {
            TaskManager.instance.jumpToQuest(this._info);
            if (this.isSelected)
            {
                return;
            };
            dispatchEvent(new TaskEvent(TaskEvent.CHANGED, this._info, this._info.data));
            this.status = "active";
        }

        protected function _deactive():void
        {
            if (this.isSelected)
            {
                this.status = "normal";
            };
        }

        public function onShow():void
        {
            this.bmpNEW.gotoAndPlay(1);
        }

        public function active():void
        {
            this._active();
        }

        public function deactive():void
        {
            this._deactive();
        }

        override public function get width():Number
        {
            return (THIS_WIDTH);
        }

        override public function get height():Number
        {
            return (THIS_HEIGHT);
        }

        public function dispose():void
        {
            this.removeEvent();
            this._info = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this.titleField)
            {
                ObjectUtils.disposeObject(this.titleField);
            };
            this.titleField = null;
            if (this.bmpNEW)
            {
                ObjectUtils.disposeObject(this.bmpNEW);
            };
            this.bmpNEW = null;
            if (this.bmpOK)
            {
                ObjectUtils.disposeObject(this.bmpOK);
            };
            this.bmpOK = null;
            if (this.bmpRecommond)
            {
                ObjectUtils.disposeObject(this.bmpRecommond);
            };
            this.bmpRecommond = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package quest

