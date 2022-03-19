// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestCateTitleView

package quest
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.filters.ColorMatrixFilter;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import road7th.utils.MovieClipWrapper;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import ddt.manager.TaskManager;
    import ddt.events.TaskEvent;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class QuestCateTitleView extends Sprite implements Disposeable 
    {

        private var _type:int;
        private var _isExpanded:Boolean;
        private var rLum:Number = 0.2225;
        private var gLum:Number = 0.7169;
        private var bLum:Number = 0.0606;
        private var bwMatrix:Array = [rLum, gLum, bLum, 0, 0, rLum, gLum, bLum, 0, 0, rLum, gLum, bLum, 0, 0, 0, 0, 0, 1, 0];
        private var cmf:ColorMatrixFilter;
        private var titleImg:ScaleFrameImage;
        private var bmpNEW:MovieClip;
        private var bmpOK:Bitmap;
        private var bmpRecommond:Bitmap;
        private var _expandBg:Bitmap;
        private var _hasNewTask:MovieClipWrapper;

        public function QuestCateTitleView(_arg_1:int=0)
        {
            this._type = _arg_1;
            this.cmf = new ColorMatrixFilter(this.bwMatrix);
            this.initView();
            this.initEvent();
            this.isExpanded = false;
        }

        override public function get width():Number
        {
            return (this.titleImg.width);
        }

        override public function get height():Number
        {
            return (this.titleImg.height);
        }

        private function initView():void
        {
            buttonMode = true;
            this._expandBg = ComponentFactory.Instance.creatBitmap("asset.core.QuestCateExpandBgAsset");
            this._expandBg.visible = false;
            addChild(this._expandBg);
            this.titleImg = ComponentFactory.Instance.creat("core.quest.MCQuestCateTitle");
            addChild(this.titleImg);
            this.bmpNEW = (ClassUtils.CreatInstance("asset.quest.newMovie") as MovieClip);
            this.bmpNEW.visible = false;
            addChild(this.bmpNEW);
            PositionUtils.setPos(this.bmpNEW, "quest.bmpNEWPos");
            this.bmpOK = ComponentFactory.Instance.creat("asset.core.quest.textImg.OK");
            this.bmpOK.visible = false;
            PositionUtils.setPos(this.bmpOK, "asset.core.questcateTile.okPos");
            addChild(this.bmpOK);
            this.bmpRecommond = ComponentFactory.Instance.creatBitmap("asset.core.quest.recommend");
            this.bmpRecommond.rotation = 15;
            this.bmpRecommond.smoothing = true;
            PositionUtils.setPos(this.bmpRecommond, "quest.cateTitleView.recommendPos");
            this.bmpRecommond.visible = false;
            addChild(this.bmpRecommond);
        }

        private function initEvent():void
        {
            TaskManager.instance.addEventListener(TaskEvent.NEW_TASK_SHOW, this._hasNewTaskMovic);
        }

        public function set taskStyle(_arg_1:int):void
        {
        }

        public function set enable(_arg_1:Boolean):void
        {
            if ((!(_arg_1)))
            {
                filters = [this.cmf];
                buttonMode = false;
                mouseChildren = false;
                mouseEnabled = false;
            }
            else
            {
                filters = null;
                buttonMode = true;
                mouseEnabled = true;
                mouseChildren = true;
            };
        }

        public function get isExpanded():Boolean
        {
            return (this._isExpanded);
        }

        public function _hasNewTaskMovic(_arg_1:TaskEvent):void
        {
            if (_arg_1.info.Type == this._type)
            {
                this._hasNewTask = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("core.quest.GetNewQuestTaskMovie"), false, true);
                this._hasNewTask.movie.addEventListener(Event.ADDED_TO_STAGE, this.__addNewQuestMovieToStage);
                this._hasNewTask.addEventListener(Event.COMPLETE, this.removeNewQuestMovie);
                addChild(this._hasNewTask.movie);
            };
        }

        private function __addNewQuestMovieToStage(_arg_1:Event=null):void
        {
            if (this._hasNewTask)
            {
                this._hasNewTask.movie.removeEventListener(Event.ADDED_TO_STAGE, this.__addNewQuestMovieToStage);
                this._hasNewTask.play();
            };
        }

        public function removeNewQuestMovie(_arg_1:Event=null):void
        {
            if (this._hasNewTask)
            {
                this._hasNewTask.removeEventListener(Event.COMPLETE, this.removeNewQuestMovie);
                ObjectUtils.disposeObject(this._hasNewTask.movie);
                ObjectUtils.disposeObject(this._hasNewTask);
                this._hasNewTask = null;
            };
        }

        public function set isExpanded(_arg_1:Boolean):void
        {
            this._isExpanded = _arg_1;
            if (_arg_1 == true)
            {
                this.titleImg.setFrame((this._type + 7));
            }
            else
            {
                this.titleImg.setFrame((this._type + 1));
            };
            this._expandBg.visible = this._isExpanded;
        }

        public function haveNew():void
        {
            this.bmpNEW.visible = true;
            this.bmpNEW.gotoAndPlay(1);
            this.bmpOK.visible = false;
            this.bmpRecommond.visible = false;
        }

        public function haveCompleted():void
        {
            this.bmpNEW.visible = false;
            this.bmpOK.visible = true;
            this.bmpRecommond.visible = false;
        }

        public function haveNoTag():void
        {
            this.bmpNEW.visible = false;
            this.bmpOK.visible = false;
            this.bmpRecommond.visible = false;
        }

        public function haveRecommond():void
        {
            this.bmpNEW.visible = false;
            this.bmpOK.visible = false;
            this.bmpRecommond.visible = true;
        }

        public function dispose():void
        {
            this.bwMatrix = null;
            this.cmf = null;
            if (this._hasNewTask)
            {
                this._hasNewTask.movie.removeEventListener(Event.ADDED_TO_STAGE, this.__addNewQuestMovieToStage);
                this._hasNewTask.removeEventListener(Event.COMPLETE, this.removeNewQuestMovie);
                ObjectUtils.disposeObject(this._hasNewTask.movie);
                ObjectUtils.disposeObject(this._hasNewTask);
                this._hasNewTask = null;
            };
            TaskManager.instance.removeEventListener(TaskEvent.NEW_TASK_SHOW, this._hasNewTaskMovic);
            if (this.titleImg)
            {
                ObjectUtils.disposeObject(this.titleImg);
            };
            this.titleImg = null;
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

