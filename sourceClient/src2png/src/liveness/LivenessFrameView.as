// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//liveness.LivenessFrameView

package liveness
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import flash.display.Shape;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import __AS3__.vec.Vector;
    import ddt.view.tips.OneLineTipUseHtmlText;
    import com.pickgliss.events.FrameEvent;
    import road7th.comm.PackageIn;
    import consortion.ConsortionModelControl;
    import ddt.manager.PlayerManager;
    import ddt.manager.ServerConfigManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.TimeManager;
    import consortion.event.ConsortionEvent;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.DropGoodsManager;
    import flash.geom.Point;
    import ddt.data.quest.QuestInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import ddt.manager.TaskManager;
    import com.greensock.TweenLite;
    import ddt.events.LivenessEvent;
    import ddt.manager.SocketManager;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import consortion.ConsortionModel;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class LivenessFrameView extends Frame 
    {

        private var _titleImg:Bitmap;
        private var _bg:Bitmap;
        private var _livenessProgress:Bitmap;
        private var _livenessBg:Bitmap;
        private var _progressMask:Shape;
        private var _livenessValueDesc:FilterFrameText;
        private var _livenessValue:FilterFrameText;
        private var _bigStarMovie:MovieClip;
        private var _listTitle1:FilterFrameText;
        private var _listTitle2:FilterFrameText;
        private var _listTitle3:FilterFrameText;
        private var _listTitle4:FilterFrameText;
        private var _itemPanel:ScrollPanel;
        private var _itemVBox:VBox;
        private var _livenessBoxList:Vector.<LivenessBox>;
        private var _passCount:uint;
        private var _itemList:Vector.<LivenessItem>;
        private var _newLivenessValue:uint;
        private var _taskList:Array;
        private var _boxStatus:Vector.<Boolean>;
        private var _starTip:OneLineTipUseHtmlText;

        public function LivenessFrameView()
        {
            escEnable = true;
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
        }

        private function __getConsortionMessage(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            var _local_6:Date = _local_2.readDate();
            var _local_7:Date = _local_2.readDate();
            var _local_8:Boolean = _local_2.readBoolean();
            var _local_9:int = _local_2.readInt();
            var _local_10:int = _local_2.readInt();
            ConsortionModelControl.Instance.model.lastPublishDate = _local_6;
            ConsortionModelControl.Instance.model.receivedQuestCount = _local_9;
            ConsortionModelControl.Instance.model.consortiaQuestCount = _local_10;
            PlayerManager.Instance.Self.consortiaInfo.Level = _local_3;
            ConsortionModelControl.Instance.model.isMaster = _local_8;
            ConsortionModelControl.Instance.model.currentTaskLevel = _local_5;
            ConsortionModelControl.Instance.model.remainPublishTime = (ConsortionModelControl.Instance.model.getLevelData(_local_3).QuestCount - _local_4);
            if (((((((_local_6.valueOf() == _local_7.valueOf()) || (_local_5 == 0)) || (_local_4 == 0)) || (!(this.checkPublishEnable()))) || (_local_10 >= ServerConfigManager.instance.getConsortiaTaskAcceptMax())) || (_local_9 >= (ConsortionModelControl.Instance.model.getLevelData(_local_3).Count * 5))))
            {
                ConsortionModelControl.Instance.model.canAcceptTask = false;
            }
            else
            {
                ConsortionModelControl.Instance.model.canAcceptTask = true;
            };
        }

        private function checkPublishEnable():Boolean
        {
            var _local_1:Date = ConsortionModelControl.Instance.model.lastPublishDate;
            var _local_2:Date = TimeManager.Instance.Now();
            if (_local_2.getFullYear() > _local_1.getFullYear())
            {
                return (true);
            };
            if (_local_2.getMonth() > _local_1.getMonth())
            {
                return (true);
            };
            if (_local_2.getDate() >= _local_1.getDate())
            {
                return (true);
            };
            return (false);
        }

        private function __updateAcceptQuestTime(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:LivenessItem;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:Date = _local_2.readDate();
            var _local_4:int = _local_2.readInt();
            ConsortionModelControl.Instance.model.consortiaQuestCount = _local_4;
            for each (_local_5 in this._itemList)
            {
                if (_local_5.type == LivenessModel.CONSORTION_TASK)
                {
                    ConsortionModelControl.Instance.model.canAcceptTask = false;
                    _local_5.reflashBtnByTpye(false);
                };
            };
        }

        private function __reflashTaskItem(_arg_1:ConsortionEvent):void
        {
            var _local_2:LivenessItem;
            for each (_local_2 in this._itemList)
            {
                if (_local_2.type == LivenessModel.CONSORTION_TASK)
                {
                    _local_2.reflashBtnByTpye(false);
                };
            };
        }

        private function __updateLivenessValue(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            var _local_5:String = _local_2.readUTF();
            if (_local_3 >= 100)
            {
                _local_3 = 100;
            };
            this._taskList = new Array();
            this._newLivenessValue = _local_3;
            this.setBoxStatusList(_local_4);
            this._taskList = _local_5.split(",");
            this.initView();
            this.initEvent();
        }

        private function __updateLivenessBoxStatus(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_8:int;
            var _local_9:ItemTemplateInfo;
            var _local_2:Array = new Array();
            var _local_3:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_4:int = _local_3.readInt();
            var _local_5:int = _local_3.readInt();
            var _local_6:int = _local_3.readInt();
            var _local_7:uint;
            while (_local_7 < _local_6)
            {
                _local_8 = _local_3.readInt();
                _local_9 = ItemManager.Instance.getTemplateById(_local_8);
                _local_2.push(_local_9);
                _local_7++;
            };
            this.setBoxStatusList(_local_4);
            this.setBoxStatus();
            DropGoodsManager.play(_local_2, this.localToGlobal(new Point((this._livenessBoxList[_local_5].x + (this._livenessBoxList[_local_5].width / 2)), this._livenessBoxList[_local_5].y)));
        }

        private function __oneKeyFinish(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:LivenessItem;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            if (_local_3 >= 100)
            {
                _local_3 = 100;
            };
            this._newLivenessValue = _local_3;
            this._livenessValue.text = String(this._newLivenessValue);
            this.reflashProgress();
            for each (_local_4 in this._itemList)
            {
                _local_4.reflashTaskProgress();
            };
        }

        private function setBoxStatusList(_arg_1:int):void
        {
            this._boxStatus = new Vector.<Boolean>();
            var _local_2:uint;
            while (_local_2 < 5)
            {
                if ((_arg_1 & (1 << _local_2)) == 0)
                {
                    this._boxStatus.push(false);
                }
                else
                {
                    this._boxStatus.push(true);
                };
                _local_2++;
            };
        }

        private function setBoxStatus():void
        {
            var _local_1:uint;
            while (_local_1 < 5)
            {
                if (this._boxStatus[_local_1])
                {
                    this._livenessBoxList[_local_1].setStatus(LivenessModel.BOX_HAS_GET);
                }
                else
                {
                    if (this._newLivenessValue >= (20 * (_local_1 + 1)))
                    {
                        this._livenessBoxList[_local_1].setStatus(LivenessModel.BOX_CAN_GET);
                    }
                    else
                    {
                        this._livenessBoxList[_local_1].setStatus(LivenessModel.BOX_CANNOT_GET);
                    };
                };
                _local_1++;
            };
        }

        private function initView():void
        {
            var _local_1:LivenessItem;
            var _local_2:uint;
            var _local_3:String;
            var _local_4:QuestInfo;
            var _local_5:LivenessItem;
            var _local_6:LivenessBox;
            this._titleImg = ComponentFactory.Instance.creatBitmap("asset.liveness.title");
            this._bg = ComponentFactory.Instance.creatBitmap("asset.liveness.allBg");
            this._livenessProgress = ComponentFactory.Instance.creatBitmap("asset.liveness.livenessProgress");
            this._livenessBg = ComponentFactory.Instance.creatBitmap("asset.liveness.ball");
            this._livenessValueDesc = ComponentFactory.Instance.creatComponentByStylename("liveness.livenessValueDescTxt");
            this._livenessValue = ComponentFactory.Instance.creatComponentByStylename("liveness.livenessValueTxt");
            this._listTitle1 = ComponentFactory.Instance.creatComponentByStylename("liveness.listTieleTxt");
            this._listTitle2 = ComponentFactory.Instance.creatComponentByStylename("liveness.listTieleTxt");
            this._listTitle3 = ComponentFactory.Instance.creatComponentByStylename("liveness.listTieleTxt");
            this._listTitle4 = ComponentFactory.Instance.creatComponentByStylename("liveness.listTieleTxt");
            PositionUtils.setPos(this._listTitle1, "liveness.listTitle1.pos");
            PositionUtils.setPos(this._listTitle2, "liveness.listTitle2.pos");
            PositionUtils.setPos(this._listTitle3, "liveness.listTitle3.pos");
            PositionUtils.setPos(this._listTitle4, "liveness.listTitle4.pos");
            this._itemPanel = ComponentFactory.Instance.creatComponentByStylename("liveness.listPanel");
            this._itemVBox = ComponentFactory.Instance.creatComponentByStylename("liveness.listVbox");
            this._livenessValueDesc.text = LanguageMgr.GetTranslation("ddt.liveness.livenessValueDesc.txt");
            this._livenessValue.text = String(this._newLivenessValue);
            this._listTitle1.text = LanguageMgr.GetTranslation("ddt.liveness.listTitle1.txt");
            this._listTitle2.text = LanguageMgr.GetTranslation("ddt.liveness.listTitle2.txt");
            this._listTitle3.text = LanguageMgr.GetTranslation("ddt.liveness.listTitle3.txt");
            this._listTitle4.text = LanguageMgr.GetTranslation("ddt.liveness.listTitle4.txt");
            this._itemList = new Vector.<LivenessItem>();
            this._itemPanel.setView(this._itemVBox);
            if (this._taskList.length > 1)
            {
                for each (_local_3 in this._taskList)
                {
                    _local_4 = TaskManager.instance.getQuestByID(int(_local_3));
                    if (!(!(_local_4)))
                    {
                        if (_local_4.Condition == LivenessModel.CONSORTION_TASK)
                        {
                            if (PlayerManager.Instance.Self.ConsortiaID != 0)
                            {
                                _local_5 = new LivenessItem(LivenessModel.CONSORTION_TASK, _local_4.id);
                            }
                            else
                            {
                                continue;
                            };
                        }
                        else
                        {
                            if (_local_4.Condition == 5)
                            {
                                if (_local_4._conditions[0].param == LivenessModel.MONSTER_REFLASH)
                                {
                                    if (PlayerManager.Instance.Self.ConsortiaID != 0)
                                    {
                                        _local_5 = new LivenessItem(LivenessModel.MONSTER_REFLASH, _local_4.id);
                                    }
                                    else
                                    {
                                        continue;
                                    };
                                }
                                else
                                {
                                    if (_local_4._conditions[0].param == LivenessModel.WORLD_BOSS)
                                    {
                                        _local_5 = new LivenessItem(LivenessModel.WORLD_BOSS, _local_4.id);
                                    }
                                    else
                                    {
                                        if (_local_4._conditions[0].param == LivenessModel.ARENA)
                                        {
                                            _local_5 = new LivenessItem(LivenessModel.ARENA, _local_4.id);
                                        }
                                        else
                                        {
                                            _local_5 = new LivenessItem(LivenessModel.NORMAL, _local_4.id);
                                        };
                                    };
                                };
                            }
                            else
                            {
                                if (_local_4.Condition == LivenessModel.CONSORTION_CONVOY)
                                {
                                    if (PlayerManager.Instance.Self.ConsortiaID != 0)
                                    {
                                        _local_5 = new LivenessItem(LivenessModel.CONSORTION_CONVOY, _local_4.id);
                                    }
                                    else
                                    {
                                        continue;
                                    };
                                }
                                else
                                {
                                    if (_local_4.Condition == LivenessModel.SINGLE_DUNGEON)
                                    {
                                        _local_5 = new LivenessItem(LivenessModel.SINGLE_DUNGEON, _local_4.id);
                                    }
                                    else
                                    {
                                        if (_local_4.Condition == LivenessModel.RANDOM_PVE)
                                        {
                                            _local_5 = new LivenessItem(LivenessModel.RANDOM_PVE, _local_4.id);
                                        }
                                        else
                                        {
                                            if (_local_4.Condition == 8)
                                            {
                                                if (_local_4._conditions[0].param == LivenessModel.RUNE)
                                                {
                                                    _local_5 = new LivenessItem(LivenessModel.RUNE, _local_4.id);
                                                }
                                                else
                                                {
                                                    _local_5 = new LivenessItem(LivenessModel.NORMAL, _local_4.id);
                                                };
                                            }
                                            else
                                            {
                                                _local_5 = new LivenessItem(LivenessModel.NORMAL, _local_4.id);
                                            };
                                        };
                                    };
                                };
                            };
                        };
                        this._itemList.push(_local_5);
                    };
                };
            };
            this._itemList = this._itemList.sort(this.sortLivenessItem);
            this._itemVBox.beginChanges();
            for each (_local_1 in this._itemList)
            {
                this._itemVBox.addChild(_local_1);
            };
            this._itemVBox.commitChanges();
            this._itemPanel.invalidateViewport();
            addToContent(this._titleImg);
            addToContent(this._bg);
            addToContent(this._listTitle1);
            addToContent(this._listTitle2);
            addToContent(this._listTitle3);
            addToContent(this._listTitle4);
            addToContent(this._itemPanel);
            addToContent(this._livenessBg);
            addToContent(this._livenessValueDesc);
            addToContent(this._livenessValue);
            this._livenessBoxList = new Vector.<LivenessBox>();
            _local_2 = 0;
            while (_local_2 < 5)
            {
                _local_6 = new LivenessBox(_local_2);
                this._livenessBoxList.push(_local_6);
                addToContent(_local_6);
                _local_2++;
            };
            this.setBoxStatus();
            this._progressMask = new Shape();
            this._progressMask.graphics.beginFill(0, 0);
            this._progressMask.graphics.drawRect(0, 0, 1, this._livenessProgress.height);
            this._progressMask.graphics.endFill();
            this._progressMask.x = this._livenessProgress.x;
            this._progressMask.y = this._livenessProgress.y;
            addToContent(this._livenessProgress);
            addToContent(this._progressMask);
            this._livenessProgress.mask = this._progressMask;
            if (this._newLivenessValue != LivenessAwardManager.Instance.model.saveLivenessValue)
            {
                this._progressMask.width = ((this._livenessProgress.width * LivenessAwardManager.Instance.model.saveLivenessValue) / 100);
                this.reflashProgress();
            }
            else
            {
                this._progressMask.width = ((this._livenessProgress.width * this._newLivenessValue) / 100);
            };
        }

        private function reflashProgress():void
        {
            TweenLite.to(this._progressMask, 1, {
                "width":((this._livenessProgress.width * this._newLivenessValue) / 100),
                "onUpdate":this.checkBoxPointMovie,
                "onComplete":this.livenessMovieEnd
            });
            LivenessAwardManager.Instance.model.saveLivenessValue = this._newLivenessValue;
        }

        private function sortLivenessItem(_arg_1:LivenessItem, _arg_2:LivenessItem):int
        {
            if (((_arg_1.info.SortLevel < 0) && (_arg_2.info.SortLevel < 0)))
            {
                if (_arg_1.info.SortLevel >= _arg_2.info.SortLevel)
                {
                    return (1);
                };
                return (-1);
            };
            if (((_arg_1.info.SortLevel >= 0) && (_arg_2.info.SortLevel < 0)))
            {
                return (1);
            };
            if (((_arg_1.info.SortLevel < 0) && (_arg_2.info.SortLevel >= 0)))
            {
                return (-1);
            };
            if (((_arg_1.info.SortLevel >= 0) && (_arg_2.info.SortLevel >= 0)))
            {
                if (((_arg_1.isComplete) && (!(_arg_2.isComplete))))
                {
                    return (1);
                };
                if (((!(_arg_1.isComplete)) && (_arg_2.isComplete)))
                {
                    return (-1);
                };
                if (_arg_1.info.SortLevel >= _arg_2.info.SortLevel)
                {
                    return (1);
                };
                return (-1);
            };
            return (1);
        }

        private function initEvent():void
        {
            LivenessAwardManager.Instance.addEventListener(LivenessEvent.TASK_DIRECT, this.__removeFrame);
            LivenessAwardManager.Instance.addEventListener(LivenessEvent.REFLASH_LIVENESS, this.__reflashLivenessFromItem);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_UPDATE_QUEST, this.__getConsortionMessage);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REQUEST_CONSORTIA_QUEST, this.__updateAcceptQuestTime);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DAILY_QUEST_UPDATE, this.__updateLivenessValue);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DAILY_QUEST_REWARD, this.__updateLivenessBoxStatus);
            ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.REFLASH_CAMPAIGN_ITEM, this.__reflashTaskItem);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DAILY_QUEST_ONE_KEY, this.__oneKeyFinish);
            LivenessAwardManager.Instance.removeEventListener(LivenessEvent.TASK_DIRECT, this.__removeFrame);
            LivenessAwardManager.Instance.removeEventListener(LivenessEvent.REFLASH_LIVENESS, this.__reflashLivenessFromItem);
        }

        private function __removeFrame(_arg_1:LivenessEvent):void
        {
            this.dispose();
        }

        private function checkBoxPointMovie():void
        {
            var _local_1:uint;
            while (_local_1 < this._livenessBoxList.length)
            {
                if ((!(LivenessAwardManager.Instance.model.pointMovieHasPlay[_local_1])))
                {
                    if (this._progressMask.width >= ((this._livenessProgress.width * 0.2) * (_local_1 + 1)))
                    {
                        if ((!(this._boxStatus[_local_1])))
                        {
                            this._livenessBoxList[_local_1].setStatus(LivenessModel.BOX_CAN_GET);
                        };
                        LivenessAwardManager.Instance.model.pointMovieHasPlay[_local_1] = true;
                    };
                };
                _local_1++;
            };
        }

        private function livenessMovieEnd():void
        {
            var _local_1:uint;
            while (_local_1 < this._livenessBoxList.length)
            {
                if ((!(LivenessAwardManager.Instance.model.pointMovieHasPlay[_local_1])))
                {
                    if (this._newLivenessValue >= (20 * (_local_1 + 1)))
                    {
                        if ((!(this._boxStatus[_local_1])))
                        {
                            this._livenessBoxList[_local_1].setStatus(LivenessModel.BOX_CAN_GET);
                        };
                        LivenessAwardManager.Instance.model.pointMovieHasPlay[_local_1] = true;
                    };
                };
                _local_1++;
            };
        }

        private function __hideBigStarTips(_arg_1:MouseEvent):void
        {
            if (this._starTip)
            {
                this._starTip.visible = false;
            };
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.__onClose();
                this.dispose();
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LIVENESS);
        }

        private function __onUIComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.LIVENESS)
            {
                UIModuleSmallLoading.Instance.hide();
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_UPDATE_QUEST, this.__getConsortionMessage);
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REQUEST_CONSORTIA_QUEST, this.__updateAcceptQuestTime);
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_QUEST_UPDATE, this.__updateLivenessValue);
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_QUEST_REWARD, this.__updateLivenessBoxStatus);
                SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_QUEST_ONE_KEY, this.__oneKeyFinish);
                ConsortionModelControl.Instance.addEventListener(ConsortionEvent.REFLASH_CAMPAIGN_ITEM, this.__reflashTaskItem);
                ConsortionModel.TASK_CAN_ACCEPT_TIME = (ServerConfigManager.instance.getConsortiaTaskVaildTime() * 1000);
                SocketManager.Instance.out.SendOpenConsortionCampaign();
                SocketManager.Instance.out.SendOpenLivenessFrame();
            };
        }

        private function __onUIProgress(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private function __onClose(_arg_1:Event=null):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            if (_arg_1)
            {
                this.dispose();
            };
        }

        private function __reflashLivenessFromItem(_arg_1:LivenessEvent):void
        {
            this._newLivenessValue = (this._newLivenessValue + int(_arg_1.info));
            this._newLivenessValue = ((this._newLivenessValue > 100) ? 100 : this._newLivenessValue);
            this._livenessValue.text = String(this._newLivenessValue);
            this.reflashProgress();
        }

        override public function dispose():void
        {
            TweenLite.killTweensOf(this._progressMask);
            this.removeEvent();
            ObjectUtils.disposeObject(this._bigStarMovie);
            this._bigStarMovie = null;
            ObjectUtils.disposeObject(this._titleImg);
            this._titleImg = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._livenessProgress);
            this._livenessProgress = null;
            ObjectUtils.disposeObject(this._livenessBg);
            this._livenessBg = null;
            ObjectUtils.disposeObject(this._progressMask);
            this._progressMask = null;
            ObjectUtils.disposeObject(this._livenessValueDesc);
            this._livenessValueDesc = null;
            ObjectUtils.disposeObject(this._livenessValue);
            this._livenessValue = null;
            ObjectUtils.disposeObject(this._listTitle1);
            this._listTitle1 = null;
            ObjectUtils.disposeObject(this._listTitle2);
            this._listTitle2 = null;
            ObjectUtils.disposeObject(this._listTitle3);
            this._listTitle3 = null;
            ObjectUtils.disposeObject(this._listTitle4);
            this._listTitle4 = null;
            ObjectUtils.disposeObject(this._itemVBox);
            this._itemVBox = null;
            ObjectUtils.disposeObject(this._itemPanel);
            this._itemPanel = null;
            ObjectUtils.disposeObject(this._itemList);
            this._itemList = null;
            if (this._livenessBoxList)
            {
                while (this._livenessBoxList.length > 0)
                {
                    ObjectUtils.disposeObject(this._livenessBoxList.shift());
                };
            };
            this._livenessBoxList = null;
            ObjectUtils.disposeObject(this._taskList);
            this._taskList = null;
            ObjectUtils.disposeObject(this._boxStatus);
            this._boxStatus = null;
            ObjectUtils.disposeObject(this._starTip);
            this._starTip = null;
            super.dispose();
        }


    }
}//package liveness

