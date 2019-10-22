function PRCVopts = det_init
    clear PRCVopts

    % dataset
    PRCVopts.dataset='data_list';

    % get current directory with forward slashes

    cwd=cd;
    cwd(cwd=='\')='/';

    % change this path to point to your copy of the detection data
    PRCVopts.datadir=[cwd '/'];

    % change this path to a writable directory for your results
    PRCVopts.resdir=[cwd '/results/'];

    % change this path to groundtruth directory
    PRCVopts.localdir=[cwd '/gt/'];

    % initialize the test set

    PRCVopts.testset='val'; % use validation data for development test set
    % PRCVopts.testset='test'; % use test set for final challenge

    % initialize main challenge paths

    PRCVopts.imgsetpath=[PRCVopts.datadir PRCVopts.dataset '/%s.txt'];
    PRCVopts.detrespath=[PRCVopts.resdir '/det_' PRCVopts.testset '_%s.txt'];

    % initialize the PRCV challenge options

    PRCVopts.classes={...
    '107'
    '59'
    '74'
    '58'
    '46'
    '155'
    '137'
    '24'
    '174'
    '165'
    '4'
    '183'
    '66'
    '96'
    '122'
    '75'
    '40'
    '27'
    '103'
    '33'
    '130'
    '185'
    '14'
    '1'
    '87'
    '117'
    '150'
    '21'
    '77'
    '127'
    '113'
    '147'
    '51'
    '110'
    '65'
    '84'
    '109'
    '3'
    '179'
    '136'
    '151'
    '128'
    '56'
    '35'
    '9'
    '62'
    '101'
    '98'
    '104'
    '73'
    '156'
    '7'
    '37'
    '32'
    '180'
    '22'
    '44'
    '64'
    '17'
    '166'
    '99'
    '78'
    '168'
    '10'
    '30'
    '13'
    '169'
    '112'
    '52'
    '149'
    '124'
    '70'
    '142'
    '148'
    '108'
    '178'
    '97'
    '171'
    '93'
    '47'
    '158'
    '167'
    '175'
    '177'
    '115'
    '85'
    '53'
    '189'
    '15'
    '28'
    '25'
    '39'
    '125'
    '68'
    '91'
    '86'
    '89'
    '6'
    '105'
    '135'
    '106'
    '132'
    '129'
    '49'
    '126'
    '144'
    '187'
    '63'
    '67'
    '176'
    '121'
    '157'
    '57'
    '20'
    '43'
    '160'
    '45'
    '41'
    '146'
    '118'
    '133'
    '131'
    '143'
    '83'
    '34'
    '36'
    '95'
    '182'
    '19'
    '119'
    '71'
    '8'
    '42'
    '31'
    '88'
    '116'
    '5'
    '111'
    '11'
    '170'
    '154'
    '94'
    '100'
    '102'
    '16'
    '23'
    '184'
    '172'
    '76'
    '81'
    '54'
    '61'
    '80'
    '55'
    '138'
    '141'
    '38'
    '145'
    '159'
    '181'
    '60'
    '50'
    '29'
    '186'
    '162'
    '114'
    '161'
    '48'
    '26'
    '12'
    '173'
    '140'
    '163'
    '92'
    '79'
    '120'
    '153'
    '90'
    '152'
    '69'
    '188'
    '2'
    '139'
    '18'
    '164'
    '82'
    '72'
    '134'
    '123'};

    PRCVopts.nclasses=length(PRCVopts.classes);	

    PRCVopts.minoverlap=0.5;

    % initialize example options

    PRCVopts.annocachepath=[PRCVopts.localdir '%s_anno.mat'];
end