// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.consortiaTask.ConsortiaTaskModel

package consortion.view.selfConsortia.consortiaTask
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;

    public class ConsortiaTaskModel extends EventDispatcher 
    {

        public static const RELEASE_TASK:int = 0;
        public static const RESET_TASK:int = 1;
        public static const SUMBIT_TASK:int = 2;
        public static const GET_TASKINFO:int = 3;
        public static const UPDATE_TASKINFO:int = 4;
        public static const SUCCESS_FAIL:int = 5;

        public var taskInfo:ConsortiaTaskInfo;
        public var isHaveTask_noRelease:Boolean = false;

        public function ConsortiaTaskModel(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
            this.initEvents();
        }

        private function initEvents():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE, this.__releaseTaskCallBack);
        }

        private function __releaseTaskCallBack(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:Boolean;
            var _local_6:Boolean;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:String;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:int;
            var _local_18:String;
            var _local_19:int;
            var _local_20:int;
            var _local_21:int;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readByte();
            if (_local_3 == SUMBIT_TASK)
            {
                _local_5 = _local_2.readBoolean();
                if ((!(_local_5)))
                {
                    this.taskInfo = null;
                };
            }
            else
            {
                if (_local_3 == SUCCESS_FAIL)
                {
                    _local_6 = _local_2.readBoolean();
                    this.taskInfo = null;
                }
                else
                {
                    if (_local_3 == UPDATE_TASKINFO)
                    {
                        _local_7 = _local_2.readInt();
                        _local_8 = _local_2.readInt();
                        _local_9 = _local_2.readInt();
                        if (this.taskInfo != null)
                        {
                            this.taskInfo.updateItemData(_local_7, _local_8, _local_9);
                        };
                    }
                    else
                    {
                        if (((_local_3 == RELEASE_TASK) || (_local_3 == RESET_TASK)))
                        {
                            _local_10 = _local_2.readInt();
                            this.taskInfo = new ConsortiaTaskInfo();
                            _local_11 = 0;
                            while (_local_11 < _local_10)
                            {
                                _local_12 = _local_2.readInt();
                                _local_13 = _local_2.readUTF();
                                this.taskInfo.addItemData(_local_12, _local_13);
                                _local_11++;
                            };
                        }
                        else
                        {
                            _local_14 = _local_2.readInt();
                            if (_local_14 > 0)
                            {
                                this.taskInfo = new ConsortiaTaskInfo();
                                _local_15 = 0;
                                while (_local_15 < _local_14)
                                {
                                    _local_16 = _local_2.readInt();
                                    _local_17 = _local_2.readInt();
                                    _local_18 = _local_2.readUTF();
                                    _local_19 = _local_2.readInt();
                                    _local_20 = _local_2.readInt();
                                    _local_21 = _local_2.readInt();
                                    this.taskInfo.addItemData(_local_16, _local_18, _local_17, _local_19, _local_20, _local_21);
                                    _local_15++;
                                };
                                this.taskInfo.sortItem();
                                this.taskInfo.exp = _local_2.readInt();
                                this.taskInfo.offer = _local_2.readInt();
                                this.taskInfo.contribution = _local_2.readInt();
                                this.taskInfo.riches = _local_2.readInt();
                                this.taskInfo.buffID = _local_2.readInt();
                                this.taskInfo.beginTime = _local_2.readDate();
                                this.taskInfo.time = _local_2.readInt();
                            }
                            else
                            {
                                if (_local_14 == -1)
                                {
                                    this.taskInfo = null;
                                    this.isHaveTask_noRelease = true;
                                }
                                else
                                {
                                    this.taskInfo = null;
                                };
                            };
                        };
                    };
                };
            };
            var _local_4:ConsortiaTaskEvent = new ConsortiaTaskEvent(ConsortiaTaskEvent.GETCONSORTIATASKINFO);
            _local_4.value = _local_3;
            dispatchEvent(_local_4);
        }

        public function showReleaseFrame():void
        {
            if (this.taskInfo != null)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.released"));
                return;
            };
            if (this.isHaveTask_noRelease)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.havetaskNoRelease"));
            };
            var _local_1:ConsortiaReleaseTaskFrame = ComponentFactory.Instance.creatComponentByStylename("ConsortiaReleaseTaskFrame");
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }


    }
}//package consortion.view.selfConsortia.consortiaTask

