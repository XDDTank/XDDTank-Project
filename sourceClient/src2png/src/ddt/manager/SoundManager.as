// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.SoundManager

package ddt.manager
{
    import flash.utils.Dictionary;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.events.NetStatusEvent;
    import flash.media.SoundTransform;
    import com.pickgliss.loader.ModuleLoader;
    import flash.media.SoundChannel;
    import flash.media.Sound;
    import flash.events.Event;
    import ddt.loader.StartupResourceLoader;
    import road7th.math.randRange;

    public class SoundManager 
    {

        private static const MusicFailedTryTime:int = 3;
        private static var _instance:SoundManager;
        public static var SITE_MAIN:String = "";

        private var currentMusicTry:int = 0;
        private var _dic:Dictionary;
        private var _music:Array;
        private var _allowSound:Boolean;
        private var _currentSound:Dictionary;
        private var _allowMusic:Boolean;
        private var _currentMusic:String;
        private var _musicLoop:Boolean;
        private var _isMusicPlaying:Boolean;
        private var _musicPlayList:Array;
        private var _musicVolume:Number;
        private var soundVolumn:Number;
        private var _nc:NetConnection;
        private var _ns:NetStream;

        public function SoundManager()
        {
            this._dic = new Dictionary();
            this._currentSound = new Dictionary(true);
            this._isMusicPlaying = false;
            this._musicLoop = false;
            this._allowMusic = true;
            this._allowSound = true;
            this._nc = new NetConnection();
            this._nc.connect(null);
            this._ns = new NetStream(this._nc);
            this._ns.bufferTime = 0.3;
            this._ns.client = this;
            this._ns.addEventListener(NetStatusEvent.NET_STATUS, this.__netStatus);
            this._musicPlayList = [];
        }

        public static function get instance():SoundManager
        {
            if (_instance == null)
            {
                _instance = new (SoundManager)();
            };
            return (_instance);
        }


        public function get allowSound():Boolean
        {
            return (this._allowSound);
        }

        public function set allowSound(_arg_1:Boolean):void
        {
            if (this._allowSound == _arg_1)
            {
                return;
            };
            this._allowSound = _arg_1;
            if ((!(this._allowSound)))
            {
                this.stopAllSound();
            };
        }

        public function get allowMusic():Boolean
        {
            return (this._allowMusic);
        }

        public function set allowMusic(_arg_1:Boolean):void
        {
            if (this._allowMusic == _arg_1)
            {
                return;
            };
            this._allowMusic = _arg_1;
            if (this._allowMusic)
            {
                this.resumeMusic();
            }
            else
            {
                this.pauseMusic();
            };
        }

        public function onPlayStatus(_arg_1:*):void
        {
        }

        public function setup(_arg_1:Array, _arg_2:String):void
        {
            this._music = ((_arg_1) ? _arg_1 : []);
            SITE_MAIN = _arg_2;
        }

        public function setConfig(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Number, _arg_4:Number):void
        {
            this.allowMusic = _arg_1;
            this.allowSound = _arg_2;
            this._musicVolume = _arg_3;
            if (this.allowMusic)
            {
                this._ns.soundTransform = new SoundTransform((_arg_3 / 100));
            };
            this.soundVolumn = _arg_4;
        }

        public function setupAudioResource(_arg_1:Boolean):void
        {
            if ((!(_arg_1)))
            {
                this.initI();
            };
            this.initII();
        }

        private function initI():void
        {
            this._dic["001"] = ModuleLoader.getDefinition("Sound001");
            this._dic["006"] = ModuleLoader.getDefinition("Sound006");
            this._dic["007"] = ModuleLoader.getDefinition("Sound007");
            this._dic["008"] = ModuleLoader.getDefinition("Sound008");
            this._dic["009"] = ModuleLoader.getDefinition("Sound009");
            this._dic["010"] = ModuleLoader.getDefinition("Sound010");
            this._dic["012"] = ModuleLoader.getDefinition("Sound012");
            this._dic["014"] = ModuleLoader.getDefinition("Sound014");
            this._dic["015"] = ModuleLoader.getDefinition("Sound015");
            this._dic["017"] = ModuleLoader.getDefinition("Sound017");
            this._dic["018"] = ModuleLoader.getDefinition("Sound018");
            this._dic["021"] = ModuleLoader.getDefinition("Sound021");
            this._dic["023"] = ModuleLoader.getDefinition("Sound023");
            this._dic["025"] = ModuleLoader.getDefinition("Sound025");
            this._dic["027"] = ModuleLoader.getDefinition("Sound027");
            this._dic["031"] = ModuleLoader.getDefinition("Sound031");
            this._dic["033"] = ModuleLoader.getDefinition("Sound033");
            this._dic["035"] = ModuleLoader.getDefinition("Sound035");
            this._dic["039"] = ModuleLoader.getDefinition("Sound039");
            this._dic["040"] = ModuleLoader.getDefinition("Sound040");
            this._dic["041"] = ModuleLoader.getDefinition("Sound041");
            this._dic["042"] = ModuleLoader.getDefinition("Sound042");
            this._dic["043"] = ModuleLoader.getDefinition("Sound043");
            this._dic["044"] = ModuleLoader.getDefinition("Sound044");
            this._dic["045"] = ModuleLoader.getDefinition("Sound045");
            this._dic["047"] = ModuleLoader.getDefinition("Sound047");
            this._dic["048"] = ModuleLoader.getDefinition("Sound048");
            this._dic["049"] = ModuleLoader.getDefinition("Sound049");
            this._dic["050"] = ModuleLoader.getDefinition("Sound050");
            this._dic["057"] = ModuleLoader.getDefinition("Sound057");
            this._dic["058"] = ModuleLoader.getDefinition("Sound058");
            this._dic["063"] = ModuleLoader.getDefinition("Sound063");
            this._dic["064"] = ModuleLoader.getDefinition("Sound064");
            this._dic["067"] = ModuleLoader.getDefinition("Sound067");
            this._dic["069"] = ModuleLoader.getDefinition("Sound069");
            this._dic["071"] = ModuleLoader.getDefinition("Sound071");
            this._dic["073"] = ModuleLoader.getDefinition("Sound073");
            this._dic["075"] = ModuleLoader.getDefinition("Sound075");
            this._dic["078"] = ModuleLoader.getDefinition("Sound078");
            this._dic["081"] = ModuleLoader.getDefinition("Sound081");
            this._dic["083"] = ModuleLoader.getDefinition("Sound083");
            this._dic["087"] = ModuleLoader.getDefinition("Sound087");
            this._dic["088"] = ModuleLoader.getDefinition("Sound088");
            this._dic["091"] = ModuleLoader.getDefinition("Sound091");
            this._dic["092"] = ModuleLoader.getDefinition("Sound092");
            this._dic["093"] = ModuleLoader.getDefinition("Sound093");
            this._dic["094"] = ModuleLoader.getDefinition("Sound094");
            this._dic["095"] = ModuleLoader.getDefinition("Sound095");
            this._dic["096"] = ModuleLoader.getDefinition("Sound096");
            this._dic["098"] = ModuleLoader.getDefinition("Sound098");
            this._dic["099"] = ModuleLoader.getDefinition("Sound099");
            this._dic["100"] = ModuleLoader.getDefinition("Sound100");
            this._dic["101"] = ModuleLoader.getDefinition("Sound101");
            this._dic["102"] = ModuleLoader.getDefinition("Sound102");
            this._dic["103"] = ModuleLoader.getDefinition("Sound103");
            this._dic["104"] = ModuleLoader.getDefinition("Sound104");
            this._dic["105"] = ModuleLoader.getDefinition("Sound105");
            this._dic["106"] = ModuleLoader.getDefinition("Sound106");
            this._dic["107"] = ModuleLoader.getDefinition("Sound107");
            this._dic["108"] = ModuleLoader.getDefinition("Sound108");
            this._dic["109"] = ModuleLoader.getDefinition("Sound109");
            this._dic["110"] = ModuleLoader.getDefinition("Sound110");
            this._dic["111"] = ModuleLoader.getDefinition("Sound111");
            this._dic["112"] = ModuleLoader.getDefinition("Sound112");
            this._dic["113"] = ModuleLoader.getDefinition("Sound113");
            this._dic["114"] = ModuleLoader.getDefinition("Sound114");
            this._dic["115"] = ModuleLoader.getDefinition("Sound115");
            this._dic["116"] = ModuleLoader.getDefinition("Sound116");
            this._dic["117"] = ModuleLoader.getDefinition("Sound117");
            this._dic["118"] = ModuleLoader.getDefinition("Sound118");
            this._dic["119"] = ModuleLoader.getDefinition("Sound119");
            this._dic["120"] = ModuleLoader.getDefinition("Sound120");
            this._dic["121"] = ModuleLoader.getDefinition("Sound121");
            this._dic["122"] = ModuleLoader.getDefinition("Sound122");
            this._dic["123"] = ModuleLoader.getDefinition("Sound123");
            this._dic["124"] = ModuleLoader.getDefinition("Sound124");
            this._dic["125"] = ModuleLoader.getDefinition("Sound125");
            this._dic["126"] = ModuleLoader.getDefinition("Sound126");
            this._dic["127"] = ModuleLoader.getDefinition("Sound127");
            this._dic["128"] = ModuleLoader.getDefinition("Sound128");
            this._dic["129"] = ModuleLoader.getDefinition("Sound129");
            this._dic["130"] = ModuleLoader.getDefinition("Sound130");
            this._dic["131"] = ModuleLoader.getDefinition("Sound131");
            this._dic["132"] = ModuleLoader.getDefinition("Sound132");
            this._dic["133"] = ModuleLoader.getDefinition("Sound133");
            this._dic["134"] = ModuleLoader.getDefinition("Sound134");
            this._dic["135"] = ModuleLoader.getDefinition("Sound135");
            this._dic["136"] = ModuleLoader.getDefinition("Sound136");
            this._dic["137"] = ModuleLoader.getDefinition("Sound137");
            this._dic["138"] = ModuleLoader.getDefinition("Sound138");
            this._dic["139"] = ModuleLoader.getDefinition("Sound139");
            this._dic["141"] = ModuleLoader.getDefinition("Sound141");
            this._dic["142"] = ModuleLoader.getDefinition("Sound142");
            this._dic["143"] = ModuleLoader.getDefinition("Sound143");
            this._dic["144"] = ModuleLoader.getDefinition("Sound144");
            this._dic["145"] = ModuleLoader.getDefinition("Sound145");
            this._dic["146"] = ModuleLoader.getDefinition("Sound146");
            this._dic["147"] = ModuleLoader.getDefinition("Sound147");
            this._dic["148"] = ModuleLoader.getDefinition("Sound148");
            this._dic["149"] = ModuleLoader.getDefinition("Sound149");
            this._dic["150"] = ModuleLoader.getDefinition("Sound150");
            this._dic["151"] = ModuleLoader.getDefinition("Sound151");
            this._dic["152"] = ModuleLoader.getDefinition("Sound152");
            this._dic["153"] = ModuleLoader.getDefinition("Sound153");
            this._dic["155"] = ModuleLoader.getDefinition("Sound155");
            this._dic["156"] = ModuleLoader.getDefinition("Sound156");
            this._dic["158"] = ModuleLoader.getDefinition("Sound158");
            this._dic["159"] = ModuleLoader.getDefinition("Sound159");
            this._dic["160"] = ModuleLoader.getDefinition("Sound160");
            this._dic["161"] = ModuleLoader.getDefinition("Sound161");
            this._dic["162"] = ModuleLoader.getDefinition("Sound162");
            this._dic["163"] = ModuleLoader.getDefinition("Sound163");
            this._dic["164"] = ModuleLoader.getDefinition("Sound164");
            this._dic["165"] = ModuleLoader.getDefinition("Sound165");
            this._dic["166"] = ModuleLoader.getDefinition("Sound166");
            this._dic["167"] = ModuleLoader.getDefinition("Sound167");
            this._dic["170"] = ModuleLoader.getDefinition("Sound170");
            this._dic["171"] = ModuleLoader.getDefinition("Sound171");
            this._dic["172"] = ModuleLoader.getDefinition("Sound172");
            this._dic["173"] = ModuleLoader.getDefinition("Sound173");
            this._dic["174"] = ModuleLoader.getDefinition("Sound174");
            this._dic["180"] = ModuleLoader.getDefinition("Sound180");
            this._dic["181"] = ModuleLoader.getDefinition("Sound181");
            this._dic["200"] = ModuleLoader.getDefinition("Sound200");
            this._dic["201"] = ModuleLoader.getDefinition("Sound201");
            this._dic["202"] = ModuleLoader.getDefinition("Sound202");
            this._dic["203"] = ModuleLoader.getDefinition("Sound203");
            this._dic["204"] = ModuleLoader.getDefinition("Sound204");
            this._dic["205"] = ModuleLoader.getDefinition("Sound205");
            this._dic["1001"] = ModuleLoader.getDefinition("Sound1001");
        }

        private function initII():void
        {
            this._dic["003"] = ModuleLoader.getDefinition("Sound003");
            this._dic["013"] = ModuleLoader.getDefinition("Sound013");
            this._dic["016"] = ModuleLoader.getDefinition("Sound016");
            this._dic["019"] = ModuleLoader.getDefinition("Sound019");
            this._dic["020"] = ModuleLoader.getDefinition("Sound020");
            this._dic["029"] = ModuleLoader.getDefinition("Sound029");
            this._dic["038"] = ModuleLoader.getDefinition("Sound038");
            this._dic["079"] = ModuleLoader.getDefinition("Sound079");
            this._dic["089"] = ModuleLoader.getDefinition("Sound089");
            this._dic["090"] = ModuleLoader.getDefinition("Sound090");
            this._dic["097"] = ModuleLoader.getDefinition("Sound097");
            this._dic["157"] = ModuleLoader.getDefinition("Sound157");
        }

        public function checkHasSound(_arg_1:String):Boolean
        {
            if (this._dic[_arg_1] != null)
            {
                return (true);
            };
            return (false);
        }

        public function initSound(_arg_1:String):void
        {
            if (this.checkHasSound(_arg_1))
            {
                return;
            };
            this._dic[_arg_1] = ModuleLoader.getDefinition(("Sound" + _arg_1));
        }

        public function play(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=true, _arg_4:Number=0):SoundChannel
        {
            if (this._dic[_arg_1] == null)
            {
                return (null);
            };
            if (this._allowSound)
            {
                try
                {
                    if ((((_arg_2) || (_arg_3)) || (!(this.isPlaying(_arg_1)))))
                    {
                        return (this.playSoundImp(_arg_1, _arg_4));
                    };
                }
                catch(e:Error)
                {
                };
            };
            return (null);
        }

        public function playButtonSound():void
        {
            this.play("008");
        }

        private function playSoundImp(_arg_1:String, _arg_2:Number):SoundChannel
        {
            var _local_3:Sound = new (this._dic[_arg_1])();
            var _local_4:SoundChannel = _local_3.play(0, _arg_2, new SoundTransform((this.soundVolumn / 100)));
            _local_4.addEventListener(Event.SOUND_COMPLETE, this.__soundComplete);
            this._currentSound[_arg_1] = _local_4;
            return (_local_4);
        }

        private function __soundComplete(_arg_1:Event):void
        {
            var _local_3:String;
            var _local_2:SoundChannel = (_arg_1.currentTarget as SoundChannel);
            _local_2.removeEventListener(Event.SOUND_COMPLETE, this.__soundComplete);
            _local_2.stop();
            for (_local_3 in this._currentSound)
            {
                if (this._currentSound[_local_3] == _local_2)
                {
                    this._currentSound[_local_3] = null;
                    return;
                };
            };
        }

        public function stop(_arg_1:String):void
        {
            if (this._currentSound[_arg_1])
            {
                this._currentSound[_arg_1].stop();
                this._currentSound[_arg_1] = null;
            };
        }

        public function stopAllSound():void
        {
            var _local_1:SoundChannel;
            for each (_local_1 in this._currentSound)
            {
                if (_local_1)
                {
                    _local_1.stop();
                };
            };
            this._currentSound = new Dictionary();
        }

        public function isPlaying(_arg_1:String):Boolean
        {
            return ((this._currentSound[_arg_1] == null) ? false : true);
        }

        public function playMusic(_arg_1:String, _arg_2:Boolean=true, _arg_3:Boolean=false):void
        {
            this.currentMusicTry = 0;
            if (((_arg_3) || (!(this._currentMusic == _arg_1))))
            {
                if (this._isMusicPlaying)
                {
                    this.stopMusic();
                };
                this.playMusicImp([_arg_1], _arg_2);
            };
        }

        private function playMusicImp(_arg_1:Array, _arg_2:Boolean):void
        {
            this._musicLoop = _arg_2;
            this._musicPlayList = _arg_1;
            if (_arg_1.length > 0)
            {
                this._currentMusic = _arg_1[0];
                this._isMusicPlaying = true;
                if (((StartupResourceLoader.firstEnterHall) && (this._currentMusic == "062")))
                {
                    return;
                };
                this._ns.play((((SITE_MAIN + "sound/") + this._currentMusic) + ".flv"));
                this._ns.soundTransform = new SoundTransform((this._musicVolume / 100));
                if ((!(this._allowMusic)))
                {
                    this._ns.removeEventListener(NetStatusEvent.NET_STATUS, this.__onMusicStaus);
                    this.pauseMusic();
                }
                else
                {
                    this._ns.addEventListener(NetStatusEvent.NET_STATUS, this.__onMusicStaus);
                };
            };
        }

        private function __onMusicStaus(_arg_1:NetStatusEvent):void
        {
            if (((_arg_1.info.code == "NetConnection.Connect.Failed") || (_arg_1.info.code == "NetStream.Play.StreamNotFound")))
            {
                if (this.currentMusicTry < MusicFailedTryTime)
                {
                    this.currentMusicTry++;
                    this._ns.play((((SITE_MAIN + "sound/") + this._currentMusic) + ".flv"));
                }
                else
                {
                    this._ns.removeEventListener(NetStatusEvent.NET_STATUS, this.__onMusicStaus);
                };
            }
            else
            {
                if (_arg_1.info.code == "NetStream.Play.Start")
                {
                    this._ns.removeEventListener(NetStatusEvent.NET_STATUS, this.__onMusicStaus);
                };
            };
        }

        public function setMusicVolumeByRatio(_arg_1:Number):void
        {
            if (this.allowMusic)
            {
                this._musicVolume = (this._musicVolume * _arg_1);
                this._ns.soundTransform = new SoundTransform((this._musicVolume / 100));
            };
        }

        public function getNowSoundTransform():SoundTransform
        {
            var _local_1:SoundTransform;
            if (this.allowSound)
            {
                _local_1 = new SoundTransform((this._musicVolume / 100));
            }
            else
            {
                _local_1 = new SoundTransform(0);
            };
            return (_local_1);
        }

        public function pauseMusic():void
        {
            if (this._isMusicPlaying)
            {
                this._ns.soundTransform = new SoundTransform(0);
                this._isMusicPlaying = false;
            };
        }

        public function resumeMusic():void
        {
            if (((this._allowMusic) && (this._currentMusic)))
            {
                this._ns.soundTransform = new SoundTransform((this._musicVolume / 100));
                this._isMusicPlaying = true;
            };
        }

        public function stopMusic():void
        {
            if (this._currentMusic)
            {
                this._isMusicPlaying = false;
                this._ns.close();
                this._currentMusic = null;
            };
        }

        public function playGameBackMusic(_arg_1:String):void
        {
            this.playMusicImp([_arg_1, _arg_1], false);
        }

        private function __netStatus(_arg_1:NetStatusEvent):void
        {
            var _local_2:int;
            if (_arg_1.info.code == "NetStream.Play.Stop")
            {
                if (this._musicLoop)
                {
                    this.playMusicImp(this._musicPlayList, true);
                }
                else
                {
                    if (this._musicPlayList.length > 0)
                    {
                        this.playMusicImp(this._musicPlayList, false);
                    }
                    else
                    {
                        _local_2 = randRange(0, (this._music.length - 1));
                        this.playMusicImp([this._music[_local_2]], false);
                    };
                };
            };
        }

        public function onMetaData(_arg_1:Object):void
        {
        }

        public function onXMPData(_arg_1:Object):void
        {
        }

        public function onCuePoint(_arg_1:Object):void
        {
        }


    }
}//package ddt.manager

