% get the current camera view
%
% CAMDOLLY Dolly camera.
% CAMERAMENU  Interactively manipulate camera.
% CAMERATOOLBAR  Interactively manipulate camera.
% CAMLOOKAT Move camera and target to view specified objects.
% CAMORBIT Orbit camera.
% CAMPAN Pan camera.
% CAMPOS Camera position.
% CAMPROJ Camera projection.
% CAMROLL Roll camera.
% CAMROTATE Camera rotation utility function.
% CAMTARGET Camera target.
% CAMUP Camera up vector.
% CAMVA Camera view angle.
% CAMZOOM Zoom camera.
% CAMPOSM Camera position from geographic coordinates
% CAMTARGM Camera target from geographic coordinates
% CAMUPM Camera UpVector from geographic coordinates
%
% cam = getCam;

function cam = getCam

  cam.CameraPosition = campos;
  cam.CameraTarget = camtarget;
  cam.CameraUpVector = camup;
  cam.CameraViewAngle = camva;

  %cam.CameraPositionMode = get(gca, 'CameraPositionMode');
  %cam.CameraTargetMode = get(gca, 'CameraTargetMode');
  %cam.CameraUpVectorMode = get(gca, 'CameraUpVectorMode');
  %cam.CameraViewAngleMode = get(gca, 'CameraViewAngleMode');
