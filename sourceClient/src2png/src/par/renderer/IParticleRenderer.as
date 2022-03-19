// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//par.renderer.IParticleRenderer

package par.renderer
{
    import __AS3__.vec.Vector;
    import par.particals.Particle;

    public interface IParticleRenderer 
    {

        function renderParticles(_arg_1:Vector.<Particle>):void;
        function addParticle(_arg_1:Particle):void;
        function removeParticle(_arg_1:Particle):void;
        function reset():void;
        function dispose():void;

    }
}//package par.renderer

